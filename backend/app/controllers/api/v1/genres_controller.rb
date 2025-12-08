# frozen_string_literal: true

module Api
  module V1
    class GenresController < ApiController
      def index
        genres = GenresFinder.call(permitted_params)
        serialized_genres = Api::V1::GenreSerializer.new(genres).serializable_hash
        render json: { genres: serialized_genres }, status: :ok
      end

      private

      def permitted_params
        params.permit(:top, :limit)
      end
    end
  end
end
