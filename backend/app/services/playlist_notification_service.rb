# frozen_string_literal: true

class PlaylistNotificationService < ApplicationService
  MILESTONES = [10, 100, 1000, 10_000].freeze

  def initialize(user)
    @user = user
  end

  def call
    playlist_count = @user.playlists.count

    return unless MILESTONES.include?(playlist_count)

    SendPlaylistMilestoneEmailJob.perform_later(@user, playlist_count)
  end
end
