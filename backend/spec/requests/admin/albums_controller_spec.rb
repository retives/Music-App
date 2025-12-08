# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AlbumsController, type: :controller do
  render_views
  let(:album) { create(:album, title: 'test_album_title') }

  context 'when logged in as admin' do
    let(:admin) { create(:admin_user) }

    before { sign_in(admin) }

    describe 'GET index' do
      let(:album_without_cover) { create(:album, has_cover: false) }
      let(:artist) { create(:artist, name: 'test_name_artist') }
      let(:song) { create(:song, title: 'test_song', album:) }

      before do
        create(:artist_song, artist:, song:)
        create(:artist_song, artist:, song: create(:song, title: 'test_song2', album: album_without_cover))
        get :index
      end

      it 'renders the index' do
        expect(response).to have_http_status(:success)
      end

      it 'renders page include caption' do
        expect(response.body).to include('Albums')
      end

      it 'renders page include title' do
        expect(response.body).to include(album.title)
      end

      it 'renders page include cover' do
        expect(response.body).to include(album.cover_url)
      end

      it 'renders page include default cover if album cover is missing' do
        expect(response.body).to include('/uploads/album_default_image.png')
      end

      it 'renders page include artist' do
        expect(response.body).to include(artist.name)
      end

      it 'renders page include song' do
        expect(response.body).to include(song.title)
      end
    end

    describe 'GET #show' do
      it 'returns a successful response' do
        get :show, params: { id: album.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET new' do
      before { get :new }

      it 'renders the form with title' do
        expect(response.body).to include('Title')
      end

      it 'renders the form with cover inputs' do
        expect(response.body).to include('Cover')
      end
    end

    describe 'POST create' do
      let(:album) { { album: { name: 'New album' } } }
      let(:create_album) { post :create, params: album }

      it 'creates a new album' do
        expect { create_album }.to change(Album, :count).by(1)
      end

      it 'redirects to the created album' do
        create_album
        expect(response).to redirect_to(admin_album_url(Album.last))
      end
    end

    describe 'GET #edit' do
      it 'returns a successful response' do
        get :edit, params: { id: album.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'PUT update' do
      let(:new_title) { 'New Album Title' }

      before { put :update, params: { id: album.id, album: { title: new_title } } }

      it 'updates the album with valid attributes' do
        album.reload
        expect(album.title).to eq(new_title)
      end

      it 'redirects to the album' do
        expect(response).to redirect_to(admin_album_url(album))
      end
    end

    describe 'DELETE #destroy' do
      let!(:album) { create(:album) }
      let(:delete_album) { delete :destroy, params: { id: album.id } }

      it 'destroys the album' do
        expect { delete_album }.to change(Album, :count).by(-1)
      end

      it 'redirects to the albums index' do
        delete_album
        expect(response).to redirect_to(admin_albums_url)
      end

      it 'check a flash notification' do
        delete_album
        expect(flash[:notice]).to eq(I18n.t('active_admin.flash.album_deleted'))
      end
    end
  end
end
