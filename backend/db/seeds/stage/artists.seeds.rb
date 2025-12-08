# frozen_string_literal: true

ARTISTS.times do
  Artist.create(name: FFaker::Music.artist)
end

cyrillic_artists = read_seeds_data('./db/seeds/data/artists_cyrillic.json')
cyrillic_artists.each do |item|
  Artist.create(name: item['artist'])
end
