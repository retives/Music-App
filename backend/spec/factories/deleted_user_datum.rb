# frozen_string_literal: true

FactoryBot.define do
  factory :deleted_user_datum do
    sequence(:user_email) { |n| "deleted#{n}@gmail.com" }
    friends_ids { '[]' }
  end
end
