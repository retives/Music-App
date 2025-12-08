# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GenresController, type: :controller do
  describe 'GET /index' do
    before do
      setup_songs_with_genres
      setup_playlist_songs
    end

    context 'when user is either authenticated or not' do
      context 'when requesting top 5 genres' do
        before { get :index, params: { top: true, limit: 5 } }

        it 'shows top 5 genres DESC by popularity' do
          top_genres = response.parsed_body['genres']['data']
          expect(top_genres.count).to eq(5)
        end

        it 'returns proper attributes for the serialized genre' do
          top_genres = response.parsed_body['genres']['data']

          expect(top_genres.first.keys).to eq(%w[id type attributes])
          expect(top_genres.first['attributes']).to have_key('title')
        end
      end

      context 'when requesting certain number of genres' do
        it 'shows all genres' do
          get :index
          genres = response.parsed_body['genres']['data']
          expect(genres.count).to eq(Genre.count)
        end

        it 'shows limit = N genres' do
          get :index, params: { limit: 3 }
          genres = response.parsed_body['genres']['data']
          expect(genres.count).to eq(3)
        end
      end
    end
  end
end
