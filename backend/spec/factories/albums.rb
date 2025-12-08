# frozen_string_literal: true

FactoryBot.define do
  factory :album do
    title { FFaker::Music.album }

    transient do
      has_cover { true }
      cover_data do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/images/album_cover.png'),
          'image/png'
        )
      end
    end

    after(:build) do |album, evaluator|
      if evaluator.has_cover
        album.cover = evaluator.cover_data
        album.cover_derivatives! if album.cover.present?
      else
        album.cover = nil
      end
    end
  end
end
