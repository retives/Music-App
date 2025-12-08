# frozen_string_literal: true

module Api
  module V1
    class ReactionsController < ApiController
      before_action :authorize_access_request!
      before_action :find_playlist, only: %i[show create destroy]

      def show
        @reaction = current_user.reactions.find_by(playlist: @playlist)
        render json: { reaction: Api::V1::ReactionSerializer.new(@reaction).serializable_hash }, status: :ok
      end

      def create
        @reaction = current_user.reactions.find_or_initialize_by(playlist: @playlist)
        @reaction.status = params[:status].to_i
        if @reaction.save
          head :created
        else
          render_unprocessable_entity(details: @reaction.errors.full_messages, code: :validation_error)
        end
      end

      def destroy
        @reaction = current_user.reactions.find_by(playlist: @playlist)
        @reaction&.destroy
        head :ok
      end

      private

      def find_playlist
        @playlist = Playlist.find(params[:playlist_id])
      end
    end
  end
end
