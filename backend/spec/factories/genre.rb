# frozen_string_literal: true

FactoryBot.define do
  factory :genre do
    sequence(:title) { |n| "#{FFaker::Music.genre}-#{n}" }
  end
end
