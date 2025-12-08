# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/genres' do
  path '/api/v1/genres' do
    parameter name: :top, in: :query, type: :boolean, required: false,
              description: 'Sort by popularity (songs of certain genre are added in most playlists)'
    parameter name: :limit, in: :query, type: :integer, required: false,
              description: 'Number of genres to return (ALL by default)'

    get('Lists all genres') do
      tags 'Genres'
      produces 'application/json'
      response(200, 'successful') do
        let(:top) { true }

        include_context 'with integration test'
      end
    end
  end
end
