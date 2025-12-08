# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@gmail.com" }
    sequence(:nickname) { |n| "user#{n}" }
    password { 'MyPassword2023@' }
    password_confirmation { 'MyPassword2023@' }
    timezone { FFaker::Address.time_zone }

    transient do
      has_profile_picture { true }
      profile_picture_data do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/images/user_default_image.png'),
          'image/png'
        )
      end
    end

    after(:build) do |user, evaluator|
      if evaluator.has_profile_picture
        user.profile_picture = evaluator.profile_picture_data
        user.profile_picture_derivatives! if user.profile_picture.present?
      else
        user.profile_picture = nil
      end
    end
  end
end
