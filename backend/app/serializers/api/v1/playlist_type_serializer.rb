# frozen_string_literal: true

module Api
  module V1
    class PlaylistTypeSerializer
      include JSONAPI::Serializer

      attribute :playlist_type
    end
  end
end
