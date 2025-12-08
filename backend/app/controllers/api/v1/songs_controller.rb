# frozen_string_literal: true

module Api
  module V1
    class SongsController < ApiController
      before_action :request_authorization, only: :index

      def index
        pagy_meta, paginated_songs = SongsFinder.call(permitted_params)

        serialized_songs = Api::V1::SongSerializer.new(
          paginated_songs, serialization_options(params[:include])
        ).serializable_hash

        render json: { songs: serialized_songs, pagination_metadata: pagy_meta }, status: :ok
      end

      private

      # @option params [String] :search
      # @option params [Boolean] :popular
      # @option params [Integer] :genres_count
      # @option params [String] :sort_by created_at
      # @option params [String] :sort_order asc, desc
      # @option params [Integer] :page
      # @option params [Integer] :per_page
      # @option params [String] :include
      def permitted_params
        params.permit(:search,
                      :popular,
                      :genres_count,
                      :sort_by,
                      :sort_order,
                      :limit_per_genre,
                      :page,
                      :per_page,
                      :include)
      end

      def request_authorization
        authorize_access_request! if params[:search].present?
      end
    end
  end
end
