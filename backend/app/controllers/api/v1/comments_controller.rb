# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApiController
      before_action :check_for_authorization_header, only: %i[index]
      before_action :current_user, only: %i[index]
      before_action :authorize_access_request!, only: %i[create]
      before_action :set_playlist, only: %i[index create]

      def index
        pagy_meta, paginated_comments = PaginateService.call(scope: sorted_comments,
                                                             options: {
                                                               items: 30, page: params[:page]
                                                             })

        serialized_comments = Api::V1::CommentSerializer.new(paginated_comments).serializable_hash
        render json: { comments: serialized_comments, metadata: pagy_meta }, status: :ok
      end

      def create
        form = CommentForm.new(current_user, @playlist, comment_params[:content])

        if form.save
          render json: Api::V1::CommentSerializer.new(form.comment), status: :created
        else
          render_unprocessable_entity(details: form.errors, code: :validation_error)
        end
      end

      private

      def set_playlist
        @playlist = Playlist.find(params[:playlist_id])
        authorize @playlist, policy_class: CommentPolicy
      end

      def comment_params
        params.permit(:content, :playlist_id)
      end

      def sorted_comments
        sort_type = params[:sort_type].nil? ? :created_at : params[:sort_type]
        sort_direction = params[:sort_direction].nil? ? :desc : params[:sort_direction]

        @playlist.comments.order(sort_type => sort_direction).includes(:user)
      end
    end
  end
end
