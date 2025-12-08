# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject(:user_model) { described_class.new }

  describe 'associations' do
    it { is_expected.to have_many(:playlists).dependent(:nullify) }
    it { is_expected.to have_many(:comments).dependent(:nullify) }
    it { is_expected.to have_many(:reactions).dependent(:nullify) }
    it { is_expected.to have_many(:liked_playlists).through(:reactions).source(:playlist) }
    it { is_expected.to have_many(:disliked_playlists).through(:reactions).source(:playlist) }
    it { is_expected.to have_many(:friendships_sent).dependent(:destroy) }
    it { is_expected.to have_many(:friendships_received).dependent(:destroy) }
    it { is_expected.to have_many(:playlist_songs).dependent(:nullify) }
  end

  describe '#friendships' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    it 'returns friendships where the user is the sender or receiver' do
      friendship1 = create(:friendship, sender: user)
      friendship2 = create(:friendship, receiver: user)
      create(:friendship, sender: friend)

      expect(user.friendships).to contain_exactly(friendship1, friendship2)
    end
  end
end
