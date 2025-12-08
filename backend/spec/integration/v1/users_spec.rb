# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'users' do
  path '/api/v1/users' do
    parameter name: :user_type, in: :query, schema: { type: :string, enum: %w[popular contributor] }, required: false,
              description: 'Type of users to return (popular or contributor)'
    parameter name: :page, in: :query, type: :integer, required: false,
              description: 'Page number (default: 1)'
    parameter name: :per_page, in: :query, type: :integer, required: false,
              description: 'Number of users per page (default: 5, max 100)'

    get('Lists required users') do
      tags 'Users'

      response(200, 'successful') do
        let(:user_type) { 'popular' }
        run_test!
      end

      response(200, 'successful') do
        let(:user_type) { 'contributor' }
        run_test!
      end

      response(400, 'bad request') do
        let(:user_type) { 'invalid' }
        run_test!
      end
    end

    post('create user') do
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'test.user.01@example.com' },
              nickname: { type: :string, example: 'test_user' },
              password: { type: :string, example: 'secreT!123' },
              password_confirmation: { type: :string, example: 'secreT!123' }
            },
            required: %w[email nickname password password_confirmation]
          }
        },
        required: ['user']
      }

      response '201', 'user created' do
        let(:params) { { user: attributes_for(:user) } }

        include_context 'with integration test'
      end

      response '422', 'invalid request' do
        let(:params) { { user: { email: '' } } }

        include_context 'with integration test'
      end
    end
  end
end
