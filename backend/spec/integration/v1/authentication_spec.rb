# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'authentication' do
  path '/api/v1/login' do
    post('User login') do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :login_params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'test.user.01@example.com' },
          password: { type: :string, example: 'secreT!123' }
        },
        required: %w[email password]
      }

      let(:user) { create(:user) }

      before { post '/api/v1/login', params: login_params }

      response(200, 'User logged in') do
        let(:login_params) { { email: user.email, password: user.password } }

        run_test!
      end

      response(401, 'Invalid password') do
        let(:login_params) { { email: user.email, password: 'wrong password' } }

        include_context 'with integration test'
      end
    end
  end

  path '/api/v1/logout' do
    let(:user) { create(:user) }

    delete('User logout') do
      tags 'Authentication'
      consumes 'application/json'
      security [bearerAuth: []]

      response(200, 'User logged out') do
        let(:tokens) { JWTSessions::Session.new(payload: { user_id: user.id }, refresh_by_access_allowed: true).login }
        let(JWTSessions.access_header) { tokens[:access] }
        run_test!
      end

      response(401, 'not authorized') do
        let(JWTSessions.access_header) { 'invalid_token' }

        run_test!
      end
    end
  end
end
