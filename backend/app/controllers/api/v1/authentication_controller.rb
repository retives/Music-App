# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApiController
      before_action :authorize_access_request!, only: [:destroy]

      # POST /login
      def create
        user = User.find_by(email: params[:email])
        check_result = SignInAttemptService.new.check_login_attempts(params[:email], user_id: user&.id)
        return render_not_authorized(I18n.t('errors.too_many_attempts')) if check_result

        create_session(user, params[:password])
      end

      # DELETE /logout
      def destroy
        delete_current_session
        render json: :ok
      end

      private

      def create_session(user, password)
        if user&.authenticate(password)
          SignInAttemptService.new.reset_login_attempts(user&.id)

          access_payload = create_access_payload(user)
          refresh_payload = { user_id: user.id }

          session = JWTSessions::Session.new(payload: access_payload, refresh_payload:, refresh_by_access_allowed: true)
          render json: session.login
        else
          render_not_authorized(I18n.t('errors.authorization'))
        end
      end
    end
  end
end
