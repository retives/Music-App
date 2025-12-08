# frozen_string_literal: true

module Api
  module V1
    class AlbumSerializer
      include JSONAPI::Serializer

      set_type :album
      set_id :id

      attributes :title, :cover, :created_at, :updated_at

      has_many :songs, serializer: Api::V1::SongSerializer
    end
  end
end
