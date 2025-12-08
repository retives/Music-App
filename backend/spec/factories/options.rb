# frozen_string_literal: true

FactoryBot.define do
  handle = FFaker::Lorem.word
  factory :option do
    title { handle.capitalize }
    handle { handle }
    body { FFaker::Lorem.paragraph }
  end
end
