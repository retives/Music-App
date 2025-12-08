# frozen_string_literal: true

module Api
  module V1
    class MySongSerializer
      include JSONAPI::Serializer

      set_type :song
      set_id :id

      attributes :title

      attribute :artist_name do |object|
        object.artists.pluck(:name)
      end
    end
  end
end
