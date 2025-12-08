# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SongsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET /index' do
    context 'when user logged in' do
      before do
        request.headers['Authorization'] = "Bearer #{jwt_session_tokens[:access]}"
      end

      context 'with search query' do
        before do
          create(:song, title: 'Song 1')
          create(:song, title: 'Song 2')
          create(:song, title: 'Another title')

          get :index, params: { search: 'Song' }
        end

        it 'returns a successful HTTP status' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns the found songs' do
          songs = response.parsed_body['songs']['data']
          titles = songs.map { |song| song['attributes']['title'] }
          expect(titles).to include('Song 1', 'Song 2')
        end

        it 'does not return non-matching songs' do
          songs = response.parsed_body['songs']['data']
          titles = songs.map { |song| song['attributes']['title'] }
          expect(titles).not_to include('Another title')
        end

        it 'serializes the album cover derivatives' do
          songs = response.parsed_body['songs']['data']
          covers = songs.map { |song| song['attributes']['cover'] }
          covers.each do |cover|
            expect(cover['derivatives']).to include('large', 'medium', 'small')
          end
        end
      end

      context 'without search query' do
        before do
          create_list(:song, 2)
          get :index, params: { search: '' }
        end

        it 'returns all songs' do
          expect(response.parsed_body['songs']['data'].count).to eq(2)
        end

        it 'returns a successful HTTP status' do
          expect(response).to have_http_status(:ok)
        end

        it 'serializes the album cover derivatives' do
          expect(response.body).to match(/"large":.*"medium":.*"small":/)
        end
      end
    end

    context 'when user NOT logged in' do
      it 'returns unauthorized error' do
        get :index, params: { search: 'Some Song Name' }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is either authenticated or not' do
      context 'when requesting most popular songs' do
        before do
          setup_playlist_songs

          get :index, params: { popular: true }
        end

        it 'shows the first page of most popular songs (20 songs) by default' do
          popular_songs = response.parsed_body['songs']['data']
          expect(popular_songs.count).to eq(20)
        end

        it 'shows N = per page most popular songs' do
          get :index, params: { popular: true, per_page: 6 }
          popular_songs = response.parsed_body['songs']['data']
          expect(popular_songs.count).to eq(6)
        end

        it 'orders popular songs DESC according to their occurrence in playlists' do
          popular_songs = response.parsed_body['songs']['data']
          expect(descending?(song_occurrences_in_playlists(popular_songs))).to be_truthy
        end
      end

      context 'when requesting latest songs' do
        before do
          create_list(:song, 10)

          get :index, params: { sort_by: 'created_at', sort_order: 'desc' }
        end

        it 'shows latest songs desc' do
          latest_songs = response.parsed_body['songs']['data']
          latest_songs_ids = latest_songs.pluck('id')

          expect(descending?(latest_songs_ids)).to be_truthy
        end

        it 'breaks down the songs list into pages' do
          get :index, params: { sort_by: 'created_at', sort_order: 'desc', per_page: 3, page: 4 }

          songs = response.parsed_body['songs']['data']

          expect(songs.count).to eq(1)
        end

        it 'returns proper attributes for the serialized song' do
          latest_songs = response.parsed_body['songs']['data']

          expect(latest_songs.first.keys).to eq(%w[id type attributes relationships])
          expect(latest_songs.first['attributes']).to include('title', 'artists', 'album', 'cover', 'genre')
        end
      end

      context 'when requesting songs by genre' do
        before do
          setup_songs_with_genres
          setup_playlist_songs

          get :index, params: { genres_count: 5, limit_per_genre: 2 }
        end

        it 'shows songs by genre' do
          songs = response.parsed_body['songs']['data']
          expect(songs.count).to eq(10)
        end
      end
    end
  end
end
