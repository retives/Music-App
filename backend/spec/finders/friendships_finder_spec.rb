# frozen_string_literal: true

RSpec.describe FriendshipsFinder do
  describe 'call' do
    subject(:result) { described_class.call(params, current_user)[1] }

    let(:current_user) { create(:user) }
    let!(:friendships) do
      [
        create(:friendship, sender: current_user, status: :accepted, created_at: 1.day.ago, updated_at: 30.minutes.ago),
        create(:friendship, receiver: current_user, status: :accepted, created_at: 2.days.ago,
                            updated_at: 15.minutes.ago),
        create(:friendship, sender: current_user, status: :pending, created_at: 3.days.ago, updated_at: 10.minutes.ago),
        create(:friendship, sender: current_user, status: :pending, created_at: 4.days.ago, updated_at: 5.minutes.ago),
        create(:friendship, receiver: current_user, status: :pending, created_at: 5.days.ago,
                            updated_at: 2.minutes.ago),
        create(:friendship, receiver: current_user, status: :pending, created_at: 6.days.ago, updated_at: 1.minute.ago),
        create(:friendship, status: :accepted)
      ]
    end

    context 'when friendships without params' do
      let(:params) { {} }

      it 'returns only accepted friendships where current user is sender/receiver ordered by updated_at DESC' do
        expect(result).to eq([friendships[1], friendships[0]])
      end
    end

    context 'when friendships with params sent' do
      let(:params) { { direction: 'sent' } }

      it 'returns only pending friendships where current user is the sender ordered by created_at DESC' do
        expect(result).to eq([friendships[2], friendships[3]])
      end
    end

    context 'when friendships with params received' do
      let(:params) { { direction: 'received' } }

      it 'returns only pending friendships where current user is the receiver ordered by created_at DESC' do
        expect(result).to eq([friendships[4], friendships[5]])
      end
    end
  end
end
