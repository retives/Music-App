# frozen_string_literal: true

module Api
  module V1
    class PlaylistSerializer
      include JSONAPI::Serializer

      attribute :playlist_type
      attributes :name, :logo, :description, :number_likes_dislikes
      attribute :created_on, &:created_at
      attribute :updated_on, &:updated_at

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

      belongs_to :user, serializer: Api::V1::UserSerializer

      has_many :songs, serializer: Api::V1::SongSerializer do |object, params|
        sort_type = params[:sort_type].nil? ? 'popularity' : params[:sort_type]
        sort_direction = params[:sort_direction].nil? ? 'desc' : params[:sort_direction]

        Songs::SongsQuery.new(object).call(sort_type, sort_direction)
      end
    end
  end
end
