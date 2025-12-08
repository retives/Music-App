# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::GenresController, type: :controller do
  render_views

  context 'when logged in as admin' do
    let(:admin) { create(:admin_user) }

    before { sign_in(admin) }

    describe 'GET index' do
      let!(:genre) { create(:genre, title: 'test_genre_title') }

      before do
        get :index
      end

      it 'renders the index' do
        expect(response).to have_http_status(:success)
      end

      it 'renders page include caption' do
        expect(response.body).to include('Genres')
      end

      it 'renders page include title' do
        expect(response.body).to include(genre.title)
      end
    end

    describe 'GET new' do
      it 'renders the form with title' do
        get :new
        expect(response.body).to include('Title')
      end
    end

    describe 'POST #create' do
      let(:genre) { { title: 'Test Genre' } }

      it 'creates a new genre' do
        expect do
          post :create, params: { genre: }
        end.to change(Genre, :count).by(1)
      end

      it 'redirects to the all genres' do
        post :create, params: { genre: }
        expect(response).to redirect_to(admin_genres_url)
      end
    end
  end
end
