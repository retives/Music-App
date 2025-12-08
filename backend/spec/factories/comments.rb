# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { FFaker::Lorem.sentence }
    user
    playlist
  end
end
