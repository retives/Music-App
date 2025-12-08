# frozen_string_literal: true

class Artist < ApplicationRecord
  has_many :artist_songs, dependent: :destroy
  has_many :songs, through: :artist_songs
end
