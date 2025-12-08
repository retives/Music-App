# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'refresh' do
  path '/api/v1/refresh' do
    post('Refresh access token') do
      tags 'Refresh'
      consumes 'application/json'
      parameter name: JWTSessions.refresh_header, in: :header, type: :string

      response(200, 'Access token refreshed') do
        let(:user) { create(:user) }
        let(:tokens) { jwt_session_tokens }
        let(JWTSessions.refresh_header) { tokens[:refresh] }

        include_context 'with integration test'
      end

      response(401, 'Unauthorized') do
        let(JWTSessions.refresh_header) { 'invalid_token' }

        include_context 'with integration test'
      end
    end
  end
end
