# frozen_string_literal: true

module Api
  module V1
    class CommentSerializer
      include JSONAPI::Serializer

      attribute :user_name do |object|
        object.user&.nickname
      end

      attribute :user_picture do |object|
        if object.user.profile_picture
          derivatives = {
            large: object.user.profile_picture(:large).id,
            medium: object.user.profile_picture(:medium).id,
            small: object.user.profile_picture(:small).id,
            micro: object.user.profile_picture(:micro).id
          }
          object.user.profile_picture.as_json.merge(derivatives:)
        end
      end

      attribute :user_email do |object|
        object.user&.email
      end

      attributes :created_at, :content
    end
  end
end
