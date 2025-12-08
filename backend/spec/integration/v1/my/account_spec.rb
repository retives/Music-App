# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::My::Accounts' do
  let(:user) { create(:user) }
  let(:access_token) { "Bearer #{jwt_session_tokens[:access]}" }
  let(:Authorization) { access_token }

  path '/api/v1/my/account' do
    get('show my account') do
      tags 'My Account'
      security [bearerAuth: []]
      response(200, 'successful') do
        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }
        run_test!
      end
    end

    put('update my account') do
      tags 'My Account'
      security [bearerAuth: []]
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: '', in: :formData, schema: {
        type: :object,
        properties: {
          nickname: { type: :string },
          email: { type: :string },
          profile_picture: { type: :file, format: :binary }
        }
      }

      response(200, 'my account updated') do
        let(:"") do
          {
            nickname: 'Updated_Name',
            email: 'updated.name@example.com',
            profile_picture: Rack::Test::UploadedFile.new(
              Rails.root.join('spec/fixtures/images/user_default_image.png'),
              'image/png'
            )
          }
        end
        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }
        let(:"") do
          {
            nickname: 'Updated_Name',
            email: 'updated.name@example.com',
            profile_picture: Rack::Test::UploadedFile.new(
              Rails.root.join('spec/fixtures/images/user_default_image.png'),
              'image/png'
            )
          }
        end

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:"") { { nickname: 'Tt' } }

        run_test!
      end
    end

    delete('delete my account') do
      tags 'My Account'
      security [bearerAuth: []]
      produces 'application/json'

      response(200, 'account deleted') do
        let(:tokens) { JWTSessions::Session.new(payload: { user_id: user.id }, refresh_by_access_allowed: true).login }
        let(JWTSessions.access_header) { tokens[:access] }
        run_test! do |response|
          expect(response.status).to eq(200)
          expect(User.find_by(id: user.id)).to be_nil
        end
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }

        run_test!
      end
    end
  end
end
