# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    playlist_type { :personal }
    name { FFaker::Lorem.word }
    description { FFaker::Lorem.sentence }
    user

    transient do
      has_logo { true }
      logo_data do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/images/cover.jpg'),
          'image/jpg'
        )
      end
    end

    after(:build) do |playlist, evaluator|
      if evaluator.has_logo
        playlist.logo = evaluator.logo_data
        playlist.logo_derivatives! if playlist.logo.present?
      else
        playlist.logo = nil
      end
    end
  end
end
