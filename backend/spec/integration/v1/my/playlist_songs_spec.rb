# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::My::PlaylistSongs' do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{jwt_session_tokens[:access]}" }
  let(:playlist) { create(:playlist, user:) }
  let(:song) { create(:song) }
  let(:playlist_id) { playlist.id }
  let(:song_id) { song.id }

  path '/api/v1/my/playlists/{playlist_id}/playlist_songs' do
    post 'Creates playlist song' do
      tags 'Playlist Songs'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :playlist_id, in: :path, type: :integer, required: true
      parameter name: :song_id, in: :query, type: :integer, required: true

      response(201, 'created') do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 playlist_id: { type: :integer },
                 song_id: { type: :integer }
               },
               required: %w[id playlist_id song_id]

        run_test!
      end

      response(422, 'unprocessable entity') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     details: { type: :array, items: { type: :string } },
                     code: { type: :string }
                   },
                   required: %w[details code]
                 }
               },
               required: %w[errors]

        before { create(:playlist_song, playlist:, song:) }

        run_test! do |response|
          expect(response.code).to eq('422')
          json_response = JSON.parse(response.body)
          expect(json_response['errors']['details']).to include('Song has already been taken')
          expect(json_response['errors']['code']).to eq('unprocessable_entity')
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { '' }

        run_test!
      end

      response(404, 'playlist not found') do
        let(:playlist_id) { 'invalid' }

        run_test!
      end
    end
  end

  path '/api/v1/my/playlists/{playlist_id}/playlist_songs/{song_id}' do
    delete 'Deletes playlist song' do
      tags 'Playlist Songs'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :playlist_id, in: :path, type: :integer, required: true
      parameter name: :song_id, in: :path, type: :integer, required: true
      security [bearerAuth: []]

      response(200, 'Song removed from playlist') do
        before { create(:playlist_song, playlist:, song:) }

        include_context 'with integration test'
      end

      response(401, 'Unauthorized') do
        let(:Authorization) { '' }

        include_context 'with integration test'
      end

      response(403, 'Forbidden') do
        let(:another_user) { create(:user) }
        let(:shared_playlist) { create(:playlist, user:, playlist_type: 'shared') }
        let(:playlist_id) { shared_playlist.id }
        let(:Authorization) { "Bearer #{jwt_session_tokens_for_specific_user(another_user)[:access]}" }

        before do
          create(:playlist_song, playlist: shared_playlist, song:, user:)
          create(:friendship, sender: user, receiver: another_user, status: 'accepted')
        end

        include_context 'with integration test'
      end

      response(404, 'Song not found in playlist') do
        include_context 'with integration test'
      end
    end
  end
end
