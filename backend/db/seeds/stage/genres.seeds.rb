# frozen_string_literal: true

def unique_genre
  genre_item = FFaker::Music.genre
  genre_item = FFaker::Music.genre while Genre.exists?(title: genre_item)
  genre_item
end

GENRES.times do
  Genre.create(title: unique_genre)
end
