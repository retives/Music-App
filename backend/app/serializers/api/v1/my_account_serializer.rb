# frozen_string_literal: true

module Api
  module V1
    class MyAccountSerializer
      include JSONAPI::Serializer

      set_type :user

      attributes :nickname
      attributes :email
      attributes :profile_picture

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
