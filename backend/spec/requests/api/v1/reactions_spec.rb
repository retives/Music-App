# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::ReactionsController' do
  let(:user) { create(:user) }
  let(:access_token) { "Bearer #{jwt_session_tokens[:access]}" }
  let(:auth_headers) { { 'AUTHORIZATION' => access_token.to_s } }
  let!(:playlist) { create(:playlist) }

  describe 'GET #show' do
    let(:params) { { playlist_id: playlist.id } }

    context 'when user is authentificated and has reaction on the playlist' do
      before do
        create(:reaction, playlist_id: playlist.id, user_id: user.id, status: 1)
        get "/api/v1/playlists/#{playlist.id}/reaction", params:, headers: auth_headers
      end

      it 'returns a successful HTTP status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns reaction of the correct playlist' do
        expect(response.parsed_body['reaction']['data']['attributes']['playlist_id']).to eq(playlist.id)
      end

      it 'returns the correct status' do
        expect(response.parsed_body['reaction']['data']['attributes']['status']).to eq(1)
      end
    end

    context 'when user is authentificated but has no reaction on the playlist' do
      it 'returns a successful HTTP status without reaction' do
        get "/api/v1/playlists/#{playlist.id}/reaction", params:, headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['reaction']['data']).to be_nil
      end
    end

    context 'when user is unauth' do
      it 'returns unauthorized error' do
        get "/api/v1/playlists/#{playlist.id}/reaction"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          playlist_id: playlist.id,
          user_id: user.id,
          status: 1
        }
      end

      it 'creates a new reaction' do
        expect do
          post "/api/v1/playlists/#{playlist.id}/reaction", params: valid_params, headers: auth_headers
        end.to change(Reaction, :count).by(1)
      end

      it 'has created status' do
        post "/api/v1/playlists/#{playlist.id}/reaction", params: valid_params, headers: auth_headers

        expect(response).to have_http_status :created
      end

      it 'does not add additional on same playlist like from the same user' do
        post "/api/v1/playlists/#{playlist.id}/reaction", params: valid_params, headers: auth_headers

        expect do
          post "/api/v1/playlists/#{playlist.id}/reaction", params: valid_params, headers: auth_headers
        end.not_to change(Reaction, :count)
      end

      it 'will remove like and add dislike to playlist if user change reaction' do
        post "/api/v1/playlists/#{playlist.id}/reaction", params: valid_params, headers: auth_headers
        dislike_params = { playlist_id: playlist.id, user_id: user.id, status: 0 }

        expect do
          post "/api/v1/playlists/#{playlist.id}/reaction", params: dislike_params, headers: auth_headers
        end.not_to change(Reaction, :count)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          playlist_id: playlist.id,
          user_id: user.id,
          status: 2
        }
      end

      it 'does not create a new reaction' do
        expect do
          post "/api/v1/playlists/#{playlist.id}/reaction", params: invalid_params, headers: auth_headers
        end.not_to change(Reaction, :count)
      end

      it 'has unprocessable entity status' do
        post "/api/v1/playlists/#{playlist.id}/reaction", params: invalid_params, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user not authorized' do
      let(:valid_params) do
        {
          playlist_id: playlist.id,
          user_id: user.id,
          status: 1
        }
      end

      it 'does not create a new reaction' do
        expect do
          post "/api/v1/playlists/#{playlist.id}/reaction", params: valid_params
        end.not_to change(Reaction, :count)
      end

      it 'has unauthorized status' do
        post "/api/v1/playlists/#{playlist.id}/reaction", params: valid_params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when reaction exists' do
      let(:reaction) { create(:reaction, playlist_id: playlist.id, user_id: user.id, status: 1) }

      it 'destroys the reaction' do
        reaction

        expect do
          delete "/api/v1/playlists/#{playlist.id}/reaction", headers: auth_headers
        end.to change(Reaction, :count)
      end

      it 'has status ok' do
        delete "/api/v1/playlists/#{playlist.id}/reaction", headers: auth_headers

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when reaction does not exist' do
      let(:another_playlist) { create(:playlist) }

      it 'does not destroy any reaction' do
        expect do
          delete "/api/v1/playlists/#{another_playlist.id}/reaction", headers: auth_headers
        end.not_to change(Reaction, :count)
      end
    end
  end
end
