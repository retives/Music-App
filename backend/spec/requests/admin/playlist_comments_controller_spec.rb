# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PlaylistCommentsController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let(:playlist) { create(:playlist) }
  let(:comment) { create(:comment, user:, playlist:) }

  context 'when logged in as admin' do
    let(:admin) { create(:admin_user) }

    before { sign_in(admin) }

    describe 'GET #index' do
      before do
        user
        playlist
        comment
        get :index
      end

      it 'renders the index template' do
        expect(response).to have_http_status(:success)
      end

      it 'renders page include caption' do
        expect(response.body).to include('Playlist Comments')
      end

      it 'renders page include name' do
        expect(response.body).to include(playlist.name)
      end

      it 'renders page include user email' do
        expect(response.body).to include(user.email)
      end

      it 'renders page include comment content' do
        expect(response.body).to include(comment.content)
      end

      it 'renders page include created_at' do
        expect(response.body).to include(comment.created_at.strftime('%B %d, %Y %H:%M'))
      end

      it 'does not render the "New Playlist" button' do
        expect(response.body).not_to include('New Playlist')
      end

      it 'does not render the "Edit" link for the comment' do
        expect(response.body).not_to include('Edit')
      end
    end

    describe 'GET #show' do
      it 'returns a successful response' do
        get :show, params: { id: comment.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'DELETE #destroy' do
      before { comment }

      it 'destroys the comment' do
        expect do
          delete :destroy, params: { id: comment.id }
        end.to change(Comment, :count).by(-1)
      end

      it 'redirects to admin_playlist_comments_path after destroy' do
        delete :destroy, params: { id: comment.id }
        expect(response).to redirect_to(admin_playlist_comments_path)
      end
    end

    describe 'POST #batch_action' do
      let!(:comments) { create_list(:comment, 3) }

      it 'destroys selected comments and redirects to admin_playlist_comments_path' do
        post :batch_action, params: { batch_action: 'destroy', collection_selection: comments.map(&:id) }

        expect(response).to redirect_to(admin_playlist_comments_path)
      end
    end
  end
end
