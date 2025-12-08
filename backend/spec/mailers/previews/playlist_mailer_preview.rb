# frozen_string_literal: true

class PlaylistMailerPreview < ActionMailer::Preview
  def playlist_milestone_email
    PlaylistMailer.with(user: User.first)
      .playlist_milestone_email(PlaylistNotificationService::MILESTONES.first)
  end
end
