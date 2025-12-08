# frozen_string_literal: true

class SendPlaylistMilestoneEmailJob < ApplicationJob
  queue_as :default

  def perform(user, milestone)
    PlaylistMailer.with(user:).playlist_milestone_email(milestone).deliver_now
  end
end
