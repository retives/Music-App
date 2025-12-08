# frozen_string_literal: true

RSpec.describe FriendshipDeclinedEmailJob do
  subject(:job) { described_class.perform_now(sender, friendship_info) }

  let(:sender) { create(:user) }
  let(:receiver) { create(:user) }
  let(:friendship_info) do
    friendship = create(:friendship, sender:, receiver:)
    {
      sender_nickname: friendship.sender.nickname,
      receiver_nickname: friendship.receiver.nickname,
      email: friendship.sender.email
    }
  end
  let(:mailer) { instance_double(FriendshipMailer) }
  let(:delivery) { instance_double(ActionMailer::MessageDelivery) }

  context 'when user declined friendship' do
    it 'calls FriendshipMailer' do
      allow(FriendshipMailer).to receive(:with).with(user: sender).and_return(mailer)
      allow(mailer).to receive(:friendship_declined_email).with(friendship_info).and_return(delivery)
      allow(delivery).to receive(:deliver_now).once
      job
      expect(delivery).to have_received(:deliver_now).once
    end

    it 'sends an email' do
      expect { job }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'is in default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end
