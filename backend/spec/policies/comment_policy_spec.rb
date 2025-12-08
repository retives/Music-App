# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPolicy do
  subject(:comment_policy) { described_class.new(user, playlist) }

  let(:user) { create(:user) }
  let(:playlist) { create(:playlist, playlist_type:, user: owner) }
  let(:owner) { create(:user) }
  let(:playlist_type) { 'public' }
  let(:resolved_scope) { described_class::Scope.new(user, Playlist.all).resolve }

  describe '#index?' do
    context 'when playlist is public and user is unauthentificated' do
      let(:user) { nil }

      it 'allows viewing comments' do
        expect(comment_policy.index?).to be true
        expect(resolved_scope).to include(playlist)
      end
    end

    context 'when playlist is public and user is authentificated' do
      it 'allows viewing comments' do
        expect(comment_policy.index?).to be true
        expect(resolved_scope).to include(playlist)
      end
    end

    context 'when playlist is personal and current user is the owner' do
      let(:playlist_type) { 'personal' }
      let(:user) { owner }

      it 'allows viewing comments' do
        expect(comment_policy.index?).to be true
        expect(resolved_scope).to include(playlist)
      end
    end

    context 'when playlist is personal and current user is not the owner' do
      let(:playlist_type) { 'personal' }

      it 'does not allow viewing comments' do
        expect(comment_policy.index?).to be false
        expect(resolved_scope).not_to include(playlist)
      end
    end

    context 'when playlist is shared and current user is the owner' do
      let(:playlist_type) { 'shared' }
      let(:user) { owner }

      it 'allows viewing comments' do
        expect(comment_policy.index?).to be true
        expect(resolved_scope).to include(playlist)
      end
    end
  end

  describe '#create?' do
    context 'when playlist is public' do
      it 'allows creating a comment' do
        expect(comment_policy.create?).to be true
      end
    end

    context 'when playlist is personal' do
      let(:playlist_type) { 'personal' }

      context 'when playlist is personal and user is the owner' do
        let(:user) { owner }

        it 'allows creating a comment' do
          expect(comment_policy.create?).to be true
        end
      end

      context 'when playlist is personal and user is not the owner' do
        it 'does not allow creating a comment' do
          expect(comment_policy.create?).to be false
        end
      end
    end
  end
end
