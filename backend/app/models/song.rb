# frozen_string_literal: true

class Song < ApplicationRecord
  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs
  has_many :artist_songs, dependent: :destroy
  has_many :artists, through: :artist_songs
  belongs_to :album
  belongs_to :genre
end
