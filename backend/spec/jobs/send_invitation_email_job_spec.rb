# frozen_string_literal: true

RSpec.describe SendInvitationEmailJob do
  describe 'perform' do
    subject(:job) { described_class.perform_now(user, friend_email) }

    let(:user) { create(:user) }
    let(:mailer) { instance_double(FriendshipMailer) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

    context 'when user with provided email does not exist' do
      let(:friend_email) { 'test@email.com' }

      it 'calls FriendshipMailer' do
        allow(FriendshipMailer).to receive(:with).with(user:).and_return(mailer)
        allow(mailer).to receive(:invitation_email).with(friend_email).and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_now).once
        job
        expect(message_delivery).to have_received(:deliver_now).once
      end

      it 'sends an email' do
        expect { job }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'is in default queue' do
        expect(described_class.new.queue_name).to eq('default')
      end
    end

    context 'when user with provided email exists' do
      let(:receiver) { create(:user) }
      let(:friendship_with_token) do
        { friendship: create(:friendship, sender: user, receiver:),
          token: 'example_token' }
      end

      before do
        allow(FriendshipTokenService).to receive(:new).and_return(token_service = double)
        allow(token_service).to receive(:generate_token).with(friendship_with_token[:friendship].id)
          .and_return(friendship_with_token[:token])
      end

      it 'calls FriendshipMailer' do
        allow(FriendshipMailer).to receive(:with).with(user:).and_return(mailer)
        allow(mailer).to receive(:friend_request_email).with(*friendship_with_token.values).and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_now).once

        described_class.perform_now(user, receiver.email)

        expect(message_delivery).to have_received(:deliver_now).once
      end

      it 'sends an email' do
        expect { described_class.perform_now(user, receiver.email) }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'is in default queue' do
        expect(described_class.new.queue_name).to eq('default')
      end
    end
  end
end
