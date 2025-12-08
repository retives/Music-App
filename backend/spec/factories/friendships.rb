# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    sender factory: %i[user]
    receiver factory: %i[user]
    status { :pending }
  end
end
