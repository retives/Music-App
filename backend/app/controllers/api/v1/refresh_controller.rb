# frozen_string_literal: true

module Api
  module V1
    class RefreshController < ApiController
      before_action :authorize_refresh_request!

      def create
        session = JWTSessions::Session.new(payload: access_payload, refresh_by_access_allowed: true)
        # found_token is a token fetched from request headers (X-Refresh-Token) or cookies
        render json: session.refresh(found_token)
      end

      private

      def access_payload
        # payload here stands for refresh token payload
        user = User.find(payload['user_id'])
        create_access_payload(user)
      end
    end
  end
end
