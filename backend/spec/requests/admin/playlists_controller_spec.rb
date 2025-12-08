# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PlaylistsController, type: :controller do
  render_views
  let(:playlist) { create(:playlist, playlist_type: 'public', featured: false).decorate }

  context 'when logged in as admin' do
    let(:admin) { create(:admin_user) }

    before { sign_in(admin) }

    describe 'GET #index' do
      let(:playlist_without_logo) { create(:playlist, has_logo: false) }

      before do
        playlist
        playlist_without_logo
        get :index
      end

      it 'renders the index template' do
        expect(response).to have_http_status(:success)
      end

      it 'renders page include caption' do
        expect(response.body).to include('Playlists')
      end

      it 'renders page include name' do
        expect(response.body).to include(playlist.name)
      end

      it 'renders page include description' do
        expect(response.body).to include(playlist.description)
      end

      it 'renders page include playlist_type' do
        expect(response.body).to include(playlist.playlist_type)
      end

      it 'renders page include logo' do
        expect(response.body).to include(playlist.logo_url)
      end

      it 'renders page with default image when logo is nil' do
        expect(response.body).to include('/uploads/default_image.jpg')
      end

      it 'renders page include created_at' do
        expect(response.body).to include(playlist.created_at.strftime('%B %d, %Y %H:%M'))
      end

      it 'renders page include updated_at' do
        expect(response.body).to include(playlist.updated_at.strftime('%B %d, %Y %H:%M'))
      end

      it 'renders page include featured' do
        expect(response.body).to include(playlist.featured.to_s)
      end

      it 'does not render the "New Playlist" button' do
        expect(response.body).not_to include('New Playlist')
      end

      it 'does not render the "Delete" link for the playlist' do
        expect(response.body).not_to include('Delete')
      end
    end

    describe 'GET #show' do
      it 'returns a successful response' do
        get :show, params: { id: playlist.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET #edit' do
      before { get :edit, params: { id: playlist.id } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:success)
      end

      it 'renders page include featured' do
        expect(response.body).to include('Featured')
      end

      it 'renders page include featured with value false' do
        expect(response.body).to include('0')
      end

      it 'renders page include featured with value true' do
        playlist.update(featured: true)
        expect(response.body).to include('1')
      end
    end

    describe 'PATCH #update' do
      before { patch :update, params: { id: playlist.id, playlist: { featured: true } } }

      it 'updates the playlist with valid attributes' do
        playlist.reload
        expect(playlist.featured).to be(true)
      end

      it 'redirects to the playlist' do
        expect(response).to redirect_to(admin_playlist_url(playlist))
      end
    end
  end
end
