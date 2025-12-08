# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ArtistsController, type: :controller do
  render_views
  let!(:artist) { create(:artist) }

  context 'when logged in as admin' do
    let(:admin) { create(:admin_user) }

    before { sign_in(admin) }

    describe 'GET index' do
      let(:album) { create(:album, title: 'test_album_title') }
      let(:song) { create(:song, title: 'test_song', album:) }

      before do
        create(:artist_song, artist:, song:)
        get :index
      end

      it 'renders the index' do
        expect(response).to have_http_status(:success)
      end

      it 'renders page include caption' do
        expect(response.body).to include('Artists')
      end

      it 'renders page include name' do
        expect(response.body).to include(CGI.escapeHTML(artist.name))
      end

      it 'renders page include song' do
        expect(response.body).to include(song.title)
      end

      it 'renders page include title' do
        expect(response.body).to include(album.title)
      end
    end

    describe 'GET show' do
      it 'renders the show' do
        get :show, params: { id: artist.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET new' do
      before { get :new }

      it 'renders the new' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the form with name' do
        expect(response.body).to include('Name')
      end
    end

    describe 'POST create' do
      let(:artist) { { artist: { name: 'New Artist' } } }
      let(:create_artist) { post :create, params: artist }

      it 'creates a new artist' do
        expect { create_artist }.to change(Artist, :count).by(1)
      end

      it 'redirects to the created artist' do
        create_artist
        expect(response).to redirect_to(admin_artist_url(Artist.last))
      end
    end

    describe 'GET edit' do
      it 'returns a successful response' do
        get :edit, params: { id: artist.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PUT update' do
      let(:new_name) { 'Updated Artist' }

      before { put :update, params: { id: artist.id, artist: { name: new_name } } }

      it 'updates the artist' do
        artist.reload
        expect(artist.name).to eq('Updated Artist')
      end

      it 'redirects to the artist' do
        expect(response).to redirect_to(admin_artist_url(artist))
      end
    end

    describe 'DELETE destroy' do
      let!(:artist) { create(:artist) }
      let(:delete_artist) { delete :destroy, params: { id: artist.id } }

      it 'destroys the artist' do
        expect { delete_artist }.to change(Artist, :count).by(-1)
      end

      it 'redirects to the artists index' do
        delete_artist
        expect(response).to redirect_to(admin_artists_url)
      end
    end
  end
end
