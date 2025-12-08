# frozen_string_literal: true

module Api
  module V1
    class ReactionSerializer
      include JSONAPI::Serializer

      set_type :reaction

      attributes :playlist_id, :status
    end
  end
end
