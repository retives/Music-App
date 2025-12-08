# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::Reactions' do
  let(:user) { create(:user) }
  let(:access_token) { "Bearer #{jwt_session_tokens[:access]}" }
  let(:Authorization) { access_token }

  path '/api/v1/playlists/{playlist_id}/reaction' do
    parameter name: 'playlist_id', in: :path, type: :integer
    let(:playlist_id) { create(:playlist, user_id: user.id).id }
    let(:reaction) { create(:reaction, user_id: user.id, playlist_id:, status: 1) }

    get 'Show Playlist Reaction' do
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

      response(404, 'not found') do
        let(:playlist_id) { 999 }

        run_test!
      end
    end

    post 'Create a new reaction' do
      tags 'Reactions'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :reaction, in: :body, schema: {
        type: :object,
        properties: {
          status: { type: :integer, description: 'Status: 1 for like, 0 for dislike', enum: [0, 1] }
        },
        required: ['status']
      }

      response(201, 'created') do
        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:reaction) { { status: 2 } }

        run_test!
      end
    end

    delete 'Destroy a reaction' do
      tags 'Reactions'
      security [bearerAuth: []]
      consumes 'application/json'

      response(200, 'reaction destroyed') do
        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }

        run_test!
      end

      response(404, 'not found') do
        let(:playlist_id) { 999 }

        run_test!
      end
    end
  end
end
