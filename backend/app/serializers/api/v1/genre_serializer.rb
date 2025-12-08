# frozen_string_literal: true

module Api
  module V1
    class GenreSerializer
      include JSONAPI::Serializer

      set_type :genre
      set_id :id

      attributes :title
    end
  end
end
