# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Playlists' do
  describe 'GET #index' do
    let(:options) { { include: [:songs] } }
    let(:playlists) { instance_double(Playlist) }

    context 'without params' do
      let(:params) { {} }

      before do
        create_list(:playlist, 5, playlist_type: 'public')
        get '/api/v1/playlists', params: {}
      end

      it 'returns a successful HTTP status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with json' do
        expect(response.content_type).to include('application/json')
      end

      it 'shows all public playlists' do
        allow(PlaylistsFinder).to receive(:call).with(playlists, params).and_return(playlists)
        expect(response.parsed_body.deep_symbolize_keys[:playlists][:data].size).to eq(5)
      end

      it 'does not contain private playlists' do
        create(:playlist, playlist_type: 'private')
        allow(PlaylistsFinder).to receive(:call).with(playlists, params).and_return(playlists)
        expect(response.parsed_body.deep_symbolize_keys[:playlists][:data].size).to eq(5)
      end

      it 'serializes the playlist logo derivatives' do
        expect(response.body).to match(/"large":.*"medium":.*"small":/)
      end
    end

    context 'with search params' do
      let(:params) { { search: 'Test' } }

      before do
        create(:playlist, playlist_type: 'public', name: 'example', description: 'example')
        create(:playlist, playlist_type: 'public', name: 'Test', description: 'example')
        create(:playlist, playlist_type: 'private', name: 'Test', description: 'example')
        get '/api/v1/playlists', params:
      end

      it 'returns a successful HTTP status' do
        expect(response).to have_http_status(:ok)
      end

      it 'finds the needed playlist' do
        allow(PlaylistsFinder).to receive(:call).with(playlists, params).and_return(playlists)
        expect(response.parsed_body['playlists']['data'].size).to eq(1)
      end

      it 'finds the playlist according to search params' do
        allow(PlaylistsFinder).to receive(:call).with(playlists, params).and_return(playlists)
        expect(response.parsed_body['playlists']['data'][0]['attributes']['name']).to eq('Test')
      end

      it 'shows results only with public playlists' do
        allow(PlaylistsFinder).to receive(:call).with(playlists, params).and_return(playlists)
        expect(response.parsed_body['playlists']['data'][0]['attributes']['playlist_type']).to eq('public')
      end
    end

    context 'with sort_by and sort_order params' do
      before do
        create(:playlist, playlist_type: 'public', name: 'example', description: 'example')
        create(:playlist, playlist_type: 'public', name: 'Test', description: 'example')
        create(:playlist, playlist_type: 'private', name: 'Test', description: 'example')
        get '/api/v1/playlists', params: { sort_by: 'playlist_name', sort_order: 'ASC' }
      end

      it 'returns a successful HTTP status' do
        expect(response).to have_http_status(:ok)
      end

      it 'shows the needed playlists' do
        expect(response.parsed_body['playlists']['data'].size).to eq(2)
      end
    end
  end

  describe 'GET /api/v1/playlists/:id' do
    let(:playlist) { create(:playlist, playlist_type: 'public') }
    let(:options) { { include: %i[user songs] } }

    context 'when a guest' do
      let(:user) { nil }

      before do
        create_list(:playlist_song, 5, playlist:)
      end

      it 'returns a successful HTTP status' do
        get api_v1_playlist_path(playlist), params: options

        expect(response).to have_http_status(:ok)
      end

      it 'returns a JSON response' do
        get api_v1_playlist_path(playlist), params: options

        expect(response.content_type).to include('application/json')
      end

      it 'serializes playlist songs' do
        get api_v1_playlist_path(playlist), params: options

        expect(response.parsed_body['included'].length).to eq(6)
      end

      it 'returns a not found HTTP status if playlist does not exist' do
        get api_v1_playlist_path('not_valid')

        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message if playlist doesn not exist' do
        get api_v1_playlist_path('not_valid')

        expect(response.parsed_body['errors']).to include("Couldn't find Playlist")
      end

      it 'serializes the playlist logo derivatives' do
        get api_v1_playlist_path(playlist), params: options
        expect(response.body).to match(/"large":.*"medium":.*"small":/)
      end

      context 'with unauthenticated access' do
        let(:personal_playlist) { create(:playlist, playlist_type: :personal, user_id: create(:user).id) }

        before do
          get api_v1_playlist_path(personal_playlist)
        end

        it 'returns a 401 status' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns an error message' do
          expect(response.parsed_body['errors']).to include(I18n.t('pundit.default'))
        end
      end
    end

    context 'when an authenticated user' do
      let(:user) { create(:user) }
      let(:auth_headers) { { 'AUTHORIZATION' => "Bearer #{jwt_session_tokens[:access]}" } }

      before do
        create_list(:playlist_song, 5, playlist:)
      end

      it 'returns a successful HTTP status' do
        get api_v1_playlist_path(playlist), headers: auth_headers, params: options

        expect(response).to have_http_status(:ok)
      end

      it 'returns a JSON response' do
        get api_v1_playlist_path(playlist), headers: auth_headers, params: options

        expect(response.content_type).to include('application/json')
      end

      it 'serializes playlist songs' do
        get api_v1_playlist_path(playlist), headers: auth_headers, params: options

        expect(response.parsed_body['included'].length).to eq(6)
      end

      it 'returns a not found HTTP status if playlist does not exist' do
        get api_v1_playlist_path('not_valid'), headers: auth_headers

        expect(response).to have_http_status(:not_found)
      end

      it 'returns the error message if playlist does not exist' do
        get api_v1_playlist_path('not_valid'), headers: auth_headers

        expect(response.parsed_body['errors']).to include("Couldn't find Playlist")
      end

      context 'with not authorized access' do
        let(:personal_playlist) { create(:playlist, playlist_type: :personal, user_id: create(:user).id) }

        before do
          get api_v1_playlist_path(personal_playlist), headers: auth_headers
        end

        it 'returns a 403 status' do
          expect(response).to have_http_status(:forbidden)
        end

        it 'returns an error message' do
          expect(response.parsed_body['errors']).to include(I18n.t('pundit.default'))
        end
      end
    end
  end
end
