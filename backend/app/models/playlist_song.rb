# frozen_string_literal: true

class PlaylistSong < ApplicationRecord
  belongs_to :playlist
  belongs_to :song
  belongs_to :user

  validates :song_id, uniqueness: { scope: :playlist_id }

  scope :by_song_id, ->(song_id) { where(song_id:) }
end
