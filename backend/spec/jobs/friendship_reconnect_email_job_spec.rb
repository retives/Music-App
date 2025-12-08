# frozen_string_literal: true

RSpec.describe FriendshipReconnectEmailJob do
  describe 'perform' do
    subject(:job) { described_class.perform_now(user, friend_id) }

    let(:user) { create(:user) }
    let(:friend_id) { 123 }
    let(:mailer) { instance_double(FriendshipMailer) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

    context 'when user with provided email has friend' do
      before do
        allow(User).to receive(:find_by).with(id: friend_id).and_return(create(:user))
      end

      it 'sends a reconnect invitation email' do
        allow(FriendshipMailer).to receive(:with).with(user:).and_return(mailer)
        allow(mailer).to receive(:reconnect_invitation_email).with(user, instance_of(User)).and_return(message_delivery)
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

    context 'when user with provided email has no friend' do
      before do
        allow(User).to receive(:find_by).with(id: friend_id).and_return(nil)
        allow(FriendshipMailer).to receive(:with).with(user:).and_return(mailer)
        allow(mailer).to receive(:reconnect_invitation_email).with(user, nil).and_return(message_delivery)
        allow(message_delivery).to receive(:deliver_now).once
      end

      it 'does not send an email' do
        job
        expect(message_delivery).not_to have_received(:deliver_now)
      end
    end
  end
end
