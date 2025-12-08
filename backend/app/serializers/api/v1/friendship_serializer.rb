# frozen_string_literal: true

module Api
  module V1
    class FriendshipSerializer
      include JSONAPI::Serializer

      set_type :friendship
      set_id :id

      attributes :status, :created_at, :updated_at

      attribute :sender do |object|
        user = object.sender
        if user.profile_picture
          derivatives = {
            large: user.profile_picture(:large).id,
            medium: user.profile_picture(:medium).id,
            small: user.profile_picture(:small).id,
            micro: user.profile_picture(:micro).id
          }
        end
        {
          id: user.id,
          email: user.email,
          nickname: user.nickname,
          profile_picture: user.profile_picture&.as_json&.merge(derivatives:)
        }
      end

      attribute :receiver do |object|
        user = object.receiver
        if user.profile_picture
          derivatives = {
            large: user.profile_picture(:large).id,
            medium: user.profile_picture(:medium).id,
            small: user.profile_picture(:small).id,
            micro: user.profile_picture(:micro).id
          }
        end
        {
          id: user.id,
          email: user.email,
          nickname: user.nickname,
          profile_picture: user.profile_picture&.as_json&.merge(derivatives:)
        }
      end

      attribute :shared_playlists do |object|
        object.sender.playlists.shared_playlists.count + object.receiver.playlists.shared_playlists.count
      end
    end
  end
end
