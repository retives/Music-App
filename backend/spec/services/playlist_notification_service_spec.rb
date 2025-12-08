# frozen_string_literal: true

RSpec.describe PlaylistNotificationService do
  describe '.call' do
    subject(:service_call) { described_class.call(user) }

    let(:user) { create(:user) }

    before do
      allow(SendPlaylistMilestoneEmailJob).to receive(:perform_later)
    end

    context 'when user has reached a milestone' do
      PlaylistNotificationService::MILESTONES.each do |milestone|
        context "with #{milestone} playlists" do
          before do
            allow(user.playlists).to receive(:count).and_return(milestone)
          end

          it 'enqueues a SendPlaylistMilestoneEmailJob with the correct milestone' do
            service_call
            expect(SendPlaylistMilestoneEmailJob).to have_received(:perform_later).with(user, milestone)
          end
        end
      end
    end

    context 'when user has not reached a milestone' do
      PlaylistNotificationService::MILESTONES.each do |milestone|
        context "with #{milestone - 1} playlists" do
          before do
            allow(user.playlists).to receive(:count).and_return(milestone)
          end

          it 'does not enqueue a SendPlaylistMilestoneEmailJob with incorrect milestone' do
            service_call
            expect(SendPlaylistMilestoneEmailJob).not_to have_received(:perform_later).with(user, milestone - 1)
          end
        end
      end
    end
  end
end
