# frozen_string_literal: true

class PlaylistTypeForm
  include ActiveModel::Model

  attr_accessor :playlist_type
  attr_reader :playlist

  validates :playlist_type, inclusion: { in: Playlist.playlist_types.values }

  def initialize(user, attributes = {})
    @playlist = user.playlists.find(attributes[:id])
    if playlist.playlist_type == 'shared'
      errors.add(:playlist_type, :invalid)
    else
      self.playlist_type = attributes[:playlist_type]
    end
  end

  def update
    return false unless valid?

    update_playlist!
    true
  end

  private

  def update_playlist!
    @playlist.update!(playlist_type:)
  end
end
