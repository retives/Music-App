# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/songs' do
  path '/api/v1/songs' do
    parameter name: :search, in: :query, type: :string, required: false,
              description: 'Search by term (in title)'
    parameter name: :popular, in: :query, type: :boolean, required: false,
              description: 'Sort by popularity (songs added to most playlists)'
    parameter name: :genres_count, in: :query, type: :integer, required: false,
              description: 'Number of genres to return songs in'
    parameter name: :limit_per_genre, in: :query, type: :integer, required: false,
              description: 'Number of songs per genre to return (ALL by default)'
    parameter name: :sort_by, in: :query, schema: { type: :string, enum: %w[created_at] }, required: false,
              description: 'Sort by attribute'
    parameter name: :sort_order, in: :query, schema: { type: :string, enum: %w[asc desc] }, required: false,
              description: 'Sort order'
    parameter name: :page, in: :query, type: :integer, required: false,
              description: 'Page number (default: 1)'
    parameter name: :per_page, in: :query, type: :integer, required: false,
              description: 'Number of songs per page (default: 20)'
    parameter name: :include, in: :query, schema: { type: :string, enum: %w[album] }, required: false,
              description: 'Include related resources (e.g. album)'

    let(:user) { create(:user) }
    let(:Authorization) { "Bearer #{jwt_session_tokens[:access]}" }

    get('Lists all songs') do
      let(:include) { 'album' }
      tags 'Songs'
      security [bearerAuth: []]
      response(200, 'successful') do
        let(:search) { 'Query' }
        let(:page) { 1 }

        run_test!
      end

      response(401, 'not authorized') do
        let(:Authorization) { '' }
        let(:search) { 'Some Song Name' }

        run_test!
      end
    end
  end
end
