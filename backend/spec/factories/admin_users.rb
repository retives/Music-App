# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    sequence(:email) { |n| "admin#{n}@example.com" }
    sequence(:nickname) { |n| "admin#{n}" }
    password { 'adminUser!123' }
    password_confirmation { 'adminUser!123' }
  end
end
