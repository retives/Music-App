# frozen_string_literal: true

RSpec.describe UserReregistrationNotificationService do
  describe '.call' do
    subject(:service_call) { described_class.call(user_email) }

    let(:user_email) { 'user@example.com' }

    before do
      allow(FriendshipReconnectEmailJob).to receive(:perform_later)
    end

    context 'when a re-registered user exists' do
      let(:user) { create(:user, email: user_email) }

      before do
        create(:deleted_user_datum, user_email:, friends_ids: '[1, 2, 3]')
      end

      it 'destroys the re-registered user' do
        expect { service_call }.to change(DeletedUserDatum, :count).by(-1)
      end

      it 'calls FriendshipReconnectEmailJob for each friend_id' do
        service_call
        expect(FriendshipReconnectEmailJob).to have_received(:perform_later).exactly(3).times
      end

      it 'does not call FriendshipReconnectEmailJob if friends_ids = []' do
        create(:deleted_user_datum)
        service_call
        expect(FriendshipReconnectEmailJob).not_to have_received(:perform_later).with(no_args)
      end
    end

    context 'when no re-registered user exists' do
      it 'does not raise an error' do
        expect { service_call }.not_to raise_error
      end

      it 'does not call FriendshipReconnectEmailJob' do
        service_call
        expect(FriendshipReconnectEmailJob).not_to have_received(:perform_later)
      end

      it 'does not change DeletedUserDatum' do
        expect { service_call }.not_to change(DeletedUserDatum, :count)
      end
    end
  end
end
