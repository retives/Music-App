# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SongsController, type: :controller do
  render_views
  let(:admin) { create(:admin_user) }

  before { sign_in(admin) }

  describe 'GET index' do
    let(:album) { create(:album, title: 'test_album_title') }
    let(:artist) { create(:artist, name: 'test_name_artist') }
    let(:genre) { create(:genre, title: 'test_name_genre') }
    let(:test_song) { create(:song, title: 'test_song', album:, genre:) }

    before do
      create(:artist_song, artist:, song: test_song)
      get :index
    end

    it 'renders the index' do
      expect(response).to have_http_status(:success)
    end

    it 'renders page include caption' do
      expect(response.body).to include('Songs')
    end

    it 'renders page include title' do
      expect(response.body).to include(test_song.title)
    end

    it 'renders page include album' do
      expect(response.body).to include(album.title)
    end

    it 'renders page include artist' do
      expect(response.body).to include(artist.name)
    end

    it 'renders page include genre' do
      expect(response.body).to include(genre.title)
    end
  end

  describe 'GET #show' do
    let(:song) { create(:song) }

    it 'returns a successful response' do
      get :show, params: { id: song.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET new' do
    before { get :new }

    it 'renders the form with title' do
      expect(response.body).to include('Title')
    end

    it 'renders the form with album' do
      expect(response.body).to include('Album')
    end

    it 'renders the form with artist' do
      expect(response.body).to include('Artist')
    end

    it 'renders the form with genre' do
      expect(response.body).to include('Genre')
    end
  end

  describe 'POST #create' do
    let(:song) { create(:song) }

    it 'creates a new song' do
      expect do
        post :create, params: { song: }
      end.to change(Song, :count).by(1)
    end
  end

  describe 'GET #edit' do
    let(:song) { create(:song) }

    it 'returns a successful response' do
      get :edit, params: { id: song.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT update' do
    let(:song) { create(:song) }
    let(:new_title) { 'New Title' }

    it 'updates the song with valid attributes' do
      put :update, params: { id: song.id, song: { title: new_title } }
      song.reload
      expect(song.title).to eq(new_title)
    end

    it 'redirects to the song' do
      patch :update, params: { id: song.id, album: { title: new_title } }
      expect(response).to redirect_to(admin_song_url(song))
    end
  end

  describe 'DELETE #destroy' do
    let(:first_song) { create(:song) }
    let(:second_song) { create(:song) }

    before do
      first_song
      second_song
      delete :destroy, params: { id: first_song.id }
    end

    it 'destroys the song' do
      expect(Song.count).to eq(1)
    end

    it 'redirects to the song index' do
      expect(response).to redirect_to(admin_songs_url)
    end
  end
end
