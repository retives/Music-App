# frozen_string_literal: true

module Api
  module V1
    class PlaylistsController < ApiController
      before_action :check_for_authorization_header
      before_action :current_user, only: %i[show]
      before_action :set_playlist, only: %i[show]

      def index
        playlists = Playlist.where(playlist_type: :open)
        pagy_meta, paginated_playlists = PlaylistsFinder.call(playlists, permitted_params)

        playlists = Api::V1::MyPlaylistSerializer.new(paginated_playlists.decorate,
                                                      serialization_options(params[:include])).serializable_hash

        render json: { playlists:, pagination_metadata: pagy_meta }, status: :ok
      end

      def show
        options = { include: %i[user songs], params: playlist_params }
        playlist_serializer = Api::V1::PlaylistSerializer.new(@playlist.decorate, options).serializable_hash

        render json: playlist_serializer, status: :ok
      end

      private

      def set_playlist
        @playlist = Playlist
          .includes(:user, playlist_songs: { song: %i[album artists genre] })
          .find(params[:id])
        authorize @playlist
      end

      def playlist_params
        {
          sort_type: params[:sort_type],
          sort_direction: params[:sort_direction],
          playlist_id: params[:id]
        }
      end

      def permitted_params
        params.permit(:search,
                      :type,
                      :sort_by,
                      :sort_order,
                      :page,
                      :per_page,
                      :include)
      end
    end
  end
end
