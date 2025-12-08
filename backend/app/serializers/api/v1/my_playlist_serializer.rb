# frozen_string_literal: true

module Api
  module V1
    class MyPlaylistSerializer
      include JSONAPI::Serializer

      attribute :playlist_type
      attributes :name, :logo, :description, :number_likes_dislikes

      attribute :logo do |object|
        if object.logo
          derivatives = {
            large: object.logo(:large).id,
            medium: object.logo(:medium).id,
            small: object.logo(:small).id
          }
          object.logo.as_json.merge(derivatives:)
        end
      end

      attribute :playlist_owner_nickname do |object|
        object.user.nickname
      end

      attribute :first_ten_songs do |object|
        Api::V1::MySongSerializer.new(object.songs.order(created_at: :desc).first(10))
      end

      has_many :songs, serializer: Api::V1::MySongSerializer do |object|
        object.songs.order(created_at: :desc).first(10)
      end
    end
  end
end
