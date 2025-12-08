# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaylistPolicy do
  subject(:playlist_policy) { described_class.new(user, playlist) }

  let(:playlist) { create(:playlist) }

  context 'when an authenticated user' do
    let(:user) { create(:user) }
    let(:resolved_scope) { described_class::Scope.new(user, Playlist.all).resolve }

    it 'returns the correct scope when user accessing his private playlist' do
      playlist = create(:playlist, playlist_type: 'personal', user:)
      expect(resolved_scope).to include(playlist)
    end

    it 'returns the correct scope when user wants to access his shared playlist' do
      playlist = create(:playlist, playlist_type: 'shared', user:)
      expect(resolved_scope).to include(playlist)
    end

    it 'returns the correct scope when user accessing his public playlist' do
      playlist = create(:playlist, playlist_type: 'open', user:)
      expect(resolved_scope).to include(playlist)
    end

    it 'returns the correct scope when user accessing other user public playlist' do
      playlist = create(:playlist, playlist_type: 'open')
      expect(resolved_scope).to include(playlist)
    end

    it 'returns the correct scope when user accessing other user shared playlist' do
      playlist = create(:playlist, playlist_type: 'shared')
      expect(resolved_scope).not_to include(playlist)
    end

    it 'returns the correct scope when user accessing other user private playlist' do
      playlist = create(:playlist, playlist_type: 'personal')
      expect(resolved_scope).not_to include(playlist)
    end
  end

  context 'when a guest' do
    let(:user) { nil }
    let(:resolved_scope) { described_class::Scope.new(user, Playlist.all).resolve }

    it 'returns the correct scope when a guest accessing public playlist' do
      playlist = create(:playlist, playlist_type: 'open')
      expect(resolved_scope).to include(playlist)
    end

    it 'returns the correct scope when a guest accessing shared playlist' do
      playlist = create(:playlist, playlist_type: 'shared')
      expect(resolved_scope).not_to include(playlist)
    end

    it 'returns the correct scope when a guest accessing private playlist' do
      playlist = create(:playlist, playlist_type: 'personal')
      expect(resolved_scope).not_to include(playlist)
    end
  end
end
