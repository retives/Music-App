# frozen_string_literal: true

RSpec.describe SendPlaylistMilestoneEmailJob do
  describe 'perform' do
    subject(:job) { described_class.perform_now(user, milestone) }

    let(:user) { create(:user) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }

    context 'when user reaches milestone of created playlists' do
      let(:milestone) { 10 }
      let(:playlist_mailer) { instance_double(PlaylistMailer) }

      it 'calls PlaylistMailer' do
        allow(PlaylistMailer).to receive(:with).with(user:).and_return(playlist_mailer)
        allow(playlist_mailer).to receive(:playlist_milestone_email).with(milestone).and_return(message_delivery)
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
  end
end
