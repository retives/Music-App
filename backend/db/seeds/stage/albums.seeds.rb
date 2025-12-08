# frozen_string_literal: true

ALBUMS.times do
  Album.create(title: FFaker::Music.album, cover_data: nil)
end
