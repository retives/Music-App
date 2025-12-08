# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/playlists' do
  let(:user) { create(:user) }
  let(:access_token) { "Bearer #{jwt_session_tokens[:access]}" }
  let(:Authorization) { access_token }

  path '/api/v1/playlists' do
    parameter name: :page, in: :query, type: :integer, required: false
    parameter name: :include, in: :query, schema: { type: :string, enum: %w[songs] }, required: false
    parameter name: :search, in: :query, type: :string, required: false
    parameter name: :type, in: :query, schema: { type: :string, enum: %w[last popular featured] }, required: false
    parameter name: :sort_by, in: :query, schema: { type: :string, enum: %w[comments_count playlist_name] },
              description: 'Sort playlists by comments_count or playlist_name, default: reactions_count',
              required: false
    parameter name: :sort_order, in: :query, schema: { type: :string, enum: %w[asc desc] }, required: false
    parameter name: :per_page, in: :query, type: :integer, required: false,
              description: 'Number of playlists to return (default: 10, max 100)'

    let(:include) { 'songs' }

    get('list public playlists') do
      response(200, 'successful') do
        before do
          playlist_item = create(:playlist, playlist_type: 'open', user_id: user.id)
          create_list(:playlist_song, 12, playlist: playlist_item)
        end

        run_test!
      end

      response(200, 'successful') do
        let(:type) { 'popular' }
        run_test!
      end

      response(200, 'successful') do
        let(:type) { 'last' }
        run_test!
      end

      response(200, 'successful') do
        let(:type) { 'featured' }
        run_test!
      end
    end
  end

  path '/api/v1/playlists/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show playlist') do
      security [{}, bearerAuth: []]
      response(200, 'successful') do
        let(:id) { create(:playlist, playlist_type: 'public').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end

      response(403, 'forbidden') do
        let(:other_user) { create(:user) }
        let(:id) { create(:playlist, playlist_type: 'private', user_id: other_user.id).id }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }
        let(:id) { create(:playlist, playlist_type: 'private').id }
        run_test!
      end
    end
  end
end
