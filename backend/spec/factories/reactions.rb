# frozen_string_literal: true

FactoryBot.define do
  factory :reaction do
    user
    playlist
    status { rand(0..1) }
  end
end
