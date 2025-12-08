# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Comments' do
  let(:playlist_item) { create(:playlist, playlist_type: 'public') }

  describe 'GET /index' do
    context 'when the playlist exists' do
      before do
        create_list(:comment, 5, playlist: playlist_item)

        create(:comment, playlist: playlist_item, created_at: 1.year.ago)
        create(:comment, playlist: playlist_item, created_at: 2.years.ago)
        create(:comment, playlist: playlist_item, created_at: 2.days.ago)
        create(:comment, playlist: playlist_item, created_at: 1.day.ago)
      end

      it 'returns the comments for the playlist' do
        get api_v1_playlist_comments_path(playlist_id: playlist_item.id), params: {}

        expect(response.parsed_body['comments']['data'].size).to eq(9)
      end

      it 'returns the comments for the playlist sorted by created_at in descending order by default' do
        get api_v1_playlist_comments_path(playlist_id: playlist_item.id), params: {}

        comments = response.parsed_body['comments']['data']
        sorted_comments = comments.sort_by { |comment| comment['created_at'] }

        expect(comments).to eq(sorted_comments)
      end

      it 'returns the comments for the playlist sorted by the specified sort_type and sort_direction' do
        get api_v1_playlist_comments_path(playlist_id: playlist_item.id), params: { sort_type: 'created_at',
                                                                                    sort_direction: 'asc' }
        comments = response.parsed_body['comments']['data']
        sorted_comments = comments.sort_by { |comment| comment['created_at'] }

        expect(comments).to eq(sorted_comments)
      end

      it 'serializes the user profile_picture derivatives' do
        get api_v1_playlist_comments_path(playlist_id: playlist_item.id), params: {}
        expect(response.body).to match(/"large":.*"medium":.*"small":.*"micro":/)
      end
    end

    context 'when the playlist does not exist' do
      it 'returns an error status' do
        get api_v1_playlist_comments_path(playlist_id: 'not valid'), params: {}

        expect(response).to have_http_status(:not_found)
      end
    end

    it 'raises Pagy::VariableError for invalid page' do
      get "/api/v1/playlists/#{playlist_item.id}/comments", params: { page: -1 }

      expect(response.parsed_body['metadata']).to include('expected :page >= 1')
    end

    it 'returns the error message' do
      get api_v1_playlist_comments_path(playlist_id: 'not valid'), params: {}

      expect(response.parsed_body['errors']).to include("Couldn't find Playlist")
    end
  end

  describe 'POST #create' do
    let(:comment_content) { 'This is a test comment.' }

    context 'when user is authorized' do
      let(:user) { create(:user) }
      let(:access_token) { "Bearer #{jwt_session_tokens[:access]}" }
      let(:auth_headers) { { 'AUTHORIZATION' => access_token.to_s } }

      context 'with valid parameters' do
        before do
          post api_v1_playlist_comments_path(playlist_id: playlist_item.id),
               params: { user:, content: comment_content },
               headers: auth_headers
        end

        it 'returns a successful HTTP status' do
          expect(response).to have_http_status(:created)
        end

        it 'true comment with content' do
          expect(response.parsed_body.deep_symbolize_keys[:data][:attributes][:content]).to eq(comment_content)
        end
      end

      context 'with invalid parameters' do
        before do
          post api_v1_playlist_comments_path(playlist_id: playlist_item.id),
               params: { user:, content: '' },
               headers: auth_headers
        end

        it 'returns unprocessable entity status and error details' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'return error with empty content' do
          expect(
            response.parsed_body.deep_symbolize_keys[:errors][:details][:content]
          ).to include("can't be blank", 'is too short (minimum is 10 characters)')
        end
      end

      context 'when user try add comment in personal playlist other users' do
        let(:playlist_item) { create(:playlist, playlist_type: 'personal', user_id: create(:user).id) }

        before do
          post api_v1_playlist_comments_path(playlist_id: playlist_item.id),
               params: { user:, content: 'This is a test comment.' },
               headers: auth_headers
        end

        it 'returns error' do
          expect(response).to have_http_status(:forbidden)
          expect(
            response.parsed_body.deep_symbolize_keys[:errors]
          ).to include(I18n.t('errors.playlist_is_personal_for_comments'))
        end
      end
    end

    context 'when user is not authorized' do
      it 'returns unauthorized status' do
        post api_v1_playlist_comments_path(playlist_id: playlist_item.id),
             params: { playlist_id: playlist_item.id, content: comment_content }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
