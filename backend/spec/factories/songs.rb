# frozen_string_literal: true

FactoryBot.define do
  factory :song do
    title { FFaker::Music.song }
    genre
    album
  end
end
