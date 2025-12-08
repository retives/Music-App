# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      VALID_USER_TYPES = %w[popular contributor].freeze

      before_action :authorize_access_request!, except: %i[index create]

      def index
        if VALID_USER_TYPES.include?(params[:user_type])
          pagy_meta, paginated_users = UsersFinder.call(permitted_params)
          serialized_users = Api::V1::UserSerializer.new(paginated_users).serializable_hash
          render json: { users: serialized_users, pagination_metadata: pagy_meta }, status: :ok
        else
          render json: { error: I18n.t('errors.user_type', existing_types: VALID_USER_TYPES.join(', ')) },
                 status: :bad_request
        end
      end

      def create
        form = UserForm.new(user_params)
        if form.save
          render json: {}, status: :created, location: '/login'
          UserReregistrationNotificationService.call(user_params[:email])
        else
          render_unprocessable_entity(details: form.errors.full_messages, code: :validation_error)
        end
      end

      private

      def user_params
        params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
      end

      def permitted_params
        params.permit(:user_type, :page, :per_page)
      end
    end
  end
end
