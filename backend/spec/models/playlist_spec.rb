# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist do
  describe '#validations' do
    let(:playlist) { create(:playlist, playlist_type: :open) }

    context 'with presence' do
      it { expect(playlist.user).to be_a(User) }
    end
  end

  describe 'public_playlists' do
    it 'returns all public playlists' do
      create(:playlist, playlist_type: :open)
      create(:playlist, playlist_type: :personal)

      result = described_class.public_playlists
      expect(result).to all(be_open_playlist_type)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:commentators).through(:comments).source(:user) }
    it { is_expected.to have_many(:playlist_songs).dependent(:destroy) }
    it { is_expected.to have_many(:songs).through(:playlist_songs) }
    it { is_expected.to have_many(:reactions).dependent(:destroy) }
    it { is_expected.to have_many(:liking_users).through(:reactions).source(:user) }
    it { is_expected.to have_many(:disliking_users).through(:reactions).source(:user) }
  end
end
