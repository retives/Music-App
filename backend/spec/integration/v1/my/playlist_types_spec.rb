# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::My::PlaylistTypes' do
  let(:user) { create(:user) }
  let(:access_token) { "Bearer #{jwt_session_tokens[:access]}" }
  let(:Authorization) { access_token }

  path '/api/v1/my/playlists/{playlist_id}/playlist_type' do
    parameter name: 'playlist_id', in: :path, type: :integer, required: true

    put('update a playlist type') do
      parameter name: 'playlist_type', in: :query, schema: { type: :string, enum: %w[private shared public] },
                required: true
      tags 'My Playlists'
      security [bearerAuth: []]
      consumes 'application/json'

      response(200, 'playlist type updated') do
        let(:playlist_id) { create(:playlist, playlist_type: 'personal', user_id: user.id).id }
        let(:playlist_type) { 'public' }

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:playlist_id) { create(:playlist, playlist_type: 'shared', user_id: user.id).id }
        let(:playlist_type) { 'private' }

        run_test!
      end

      response(404, 'playlist not found') do
        let(:playlist_id) { 999 }
        let(:playlist_type) { 'public' }

        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }
        let(:playlist_id) { 1 }
        let(:playlist_type) { 'public' }

        run_test!
      end
    end
  end
end
