# frozen_string_literal: true

module Api
  module V1
    class UserSerializer
      include JSONAPI::Serializer

      attributes :email, :nickname, :profile_picture

      attribute :register_date, &:created_at

      attribute :playlists_number do |object|
        object.playlists.length
      end

      attribute :friends_count, &:friends_count

      attribute :profile_picture do |object|
        if object.profile_picture
          derivatives = {
            large: object.profile_picture(:large).id,
            medium: object.profile_picture(:medium).id,
            small: object.profile_picture(:small).id,
            micro: object.profile_picture(:micro).id
          }
          object.profile_picture.as_json.merge(derivatives:)
        end
      end
    end
  end
end
