# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::My::Reactions' do
  let(:user) { create(:user) }
  let(:access_token) { "Bearer #{jwt_session_tokens[:access]}" }
  let(:Authorization) { access_token }

  path '/api/v1/my/reactions' do
    get 'List all user reactions' do
      tags 'Reactions'
      security [bearerAuth: []]
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }

        run_test!
      end
    end
  end
end
