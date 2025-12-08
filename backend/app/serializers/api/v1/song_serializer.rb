# frozen_string_literal: true

module Api
  module V1
    class SongSerializer
      include JSONAPI::Serializer

      set_type :song
      set_id :id

      attributes :title

      attribute :artists do |object|
        object.artists.map(&:name)
      end

      attribute :album do |object|
        object.album.title
      end

      attribute :cover do |object|
        if object.album.cover
          derivatives = {
            large: object.album.cover(:large).id,
            medium: object.album.cover(:medium).id,
            small: object.album.cover(:small).id
          }
          object.album.cover.as_json.merge(derivatives:)
        end
      end

      attribute :genre do |object|
        object.genre.title
      end

      attribute :added_by do |object, params|
        if params[:playlist_id].present?
          PlaylistSong.find_by(playlist_id: params[:playlist_id], song_id: object.id).user.nickname
        else
          ''
        end
      end

      belongs_to :album, serializer: Api::V1::AlbumSerializer
      belongs_to :genre, serializer: Api::V1::GenreSerializer
    end
  end
end
