# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::My::Friendships' do
  let(:user) { create(:user) }
  let!(:friendship) { create(:friendship, sender: user, status: :pending) }
  let(:Authorization) { "Bearer #{jwt_session_tokens[:access]}" }

  path '/api/v1/my/friendships' do
    get('Lists friendships and friendship requests') do
      tags 'Friendships'
      security [bearerAuth: []]
      produces 'application/json'
      parameter name: :direction, in: :query, schema: { type: :string, enum: %w[received sent] }, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false
      parameter name: :page, in: :query, type: :integer, required: false

      response(200, 'successful') do
        include_context 'with integration test'
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }

        include_context 'with integration test'
      end
    end

    post 'Creates a friendship' do
      tags 'Friendships'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :email, in: :query, type: :string, required: true

      response(201, 'friendship created') do
        let(:email) { create(:user).email }

        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }
        let(:email) { create(:user).email }

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:email) { user.email }

        run_test!
      end
    end
  end

  path '/api/v1/my/friendships/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    put 'Accept a friendship' do
      tags 'Friendships'
      security [bearerAuth: []]
      consumes 'application/json'

      response(200, 'friendship accepted') do
        let(:id) { create(:friendship, receiver: user).id }

        run_test!
      end

      response(404, 'friendship not found') do
        let(:id) { 999 }

        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }
        let(:id) { create(:friendship, receiver: user).id }

        run_test!
      end
    end
  end

  path '/api/v1/my/friendships/{id}' do
    parameter name: 'id', in: :path, type: :integer, required: true

    delete('delete a friendships') do
      tags 'Friendships'
      security [bearerAuth: []]
      produces 'application/json'

      response(200, 'friendship deleted') do
        let(:id) { friendship.id }

        run_test! do |response|
          expect(response.status).to eq(200)
          expect(Friendship.find_by(id: friendship.id)).to be_nil
        end
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }
        let(:id) { 1 }

        run_test!
      end

      response(404, 'friendship not found') do
        let(:id) { -1 }

        run_test!
      end
    end
  end

  path '/api/v1/my/friendships/{id}' do
    get 'Shows a friendship' do
      tags 'Friendships'
      security [bearerAuth: []]
      produces 'application/json'

      parameter name: 'id', in: :path, type: :integer, required: true
      parameter name: :token, in: :query, type: :string, required: false

      let(:id) { create(:friendship, receiver: user).id }
      let(:token) { FriendshipTokenService.new.generate_token(id) }

      response(200, 'friendship found') do
        run_test!
      end

      response(422, 'invalid parameters') do
        let(:token) { 'invalid token' }
        run_test!
      end

      response(404, 'friendship not found') do
        let(:id) { -1 }
        let(:token) { FriendshipTokenService.new.generate_token(id) }
        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }
        run_test!
      end
    end
  end
end
