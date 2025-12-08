# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::My::Playlists' do
  let(:user) { create(:user) }
  let(:access_token) { "Bearer #{jwt_session_tokens[:access]}" }
  let(:Authorization) { access_token }

  path '/api/v1/my/playlists' do
    get("Lists my playlists, or lists my friends' shared playlists") do
      let(:include) { 'songs' }
      let(:playlist_type) { 'open' }

      parameter name: :playlist_type, in: :query,
                schema: { type: :string, enum: %w[shared my_playlists] }, required: true
      parameter name: :include, in: :query, schema: { type: :string, enum: %w[songs] }, required: false
      parameter name: :search, in: :query, type: :string, required: false
      parameter name: :type, in: :query, schema: { type: :string, enum: %w[last popular featured] }, required: false
      parameter name: :sort_by, in: :query, schema: { type: :string, enum: %w[comments_count playlist_name] },
                description: 'Sort playlists by comments_count or playlist_name, default: reactions_count',
                required: false
      parameter name: :sort_order, in: :query, schema: { type: :string, enum: %w[asc desc] }, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false,
                description: 'Number of playlists to return (default: 10, max 100)'

      tags 'My Playlists'
      security [bearerAuth: []]
      response(200, 'successful') do
        before do
          playlist_item = create(:playlist, playlist_type: 'personal', user_id: user.id)
          create_list(:playlist_song, 5, playlist: playlist_item)
        end

        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }
        run_test!
      end
    end

    post('create a playlist') do
      tags 'My Playlists'
      security [bearerAuth: []]
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: '', in: :formData, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          logo: { type: :file, format: :binary },
          description: { type: :string }
        },
        required: ['name']
      }

      response(201, 'playlist created') do
        let(:"") do
          {
            name: 'My Playlist',
            logo: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/cover.jpg'), 'image/jpg'),
            description: 'This is my playlist'
          }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:"") { { name: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/my/playlists/{id}' do
    parameter name: 'id', in: :path, type: :integer, required: true

    put('update a playlist') do
      tags 'My Playlists'
      security [bearerAuth: []]
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: '', in: :formData, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          logo: { type: :file, format: :binary },
          description: { type: :string }
        },
        required: ['name']
      }

      response(200, 'playlist updated') do
        let(:id) { create(:playlist, user_id: user.id).id }
        let(:"") do
          {
            name: 'My Playlist',
            logo: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/cover.jpg'), 'image/jpg'),
            description: 'This is my playlist'
          }
        end
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:id) { create(:playlist, user_id: user.id).id }
        let(:"") { { name: '' } }

        run_test!
      end

      response(404, 'playlist not found') do
        let(:id) { 999 }
        let(:"") { { name: 'My Playlist' } }

        run_test!
      end
    end

    delete('delete a playlist') do
      tags 'My Playlists'
      security [bearerAuth: []]
      produces 'application/json'

      response(200, 'playlist deleted') do
        let(:playlist) { create(:playlist, user_id: user.id) }
        let(:id) { playlist.id }

        run_test! do |response|
          expect(response.status).to eq(200)
          expect(Playlist.find_by(id: playlist.id)).to be_nil
        end
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }
        let(:id) { 1 }

        run_test!
      end

      response(404, 'playlist not found') do
        let(:id) { 999 }

        run_test!
      end
    end
  end
end
