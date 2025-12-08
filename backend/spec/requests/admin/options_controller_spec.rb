# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::OptionsController, type: :controller do
  render_views
  let!(:option) { create(:option, title: 'About', handle: 'about') }

  context 'when logged in as admin' do
    let(:admin) { create(:admin_user) }

    before { sign_in(admin) }

    describe 'GET #index' do
      before { get :index }

      it 'renders the index template' do
        expect(response).to have_http_status(:success)
      end

      it 'renders page including caption' do
        expect(response.body).to include('Options')
      end

      it 'renders page including title' do
        expect(response.body).to include(option.title)
      end

      it 'renders page including handle' do
        expect(response.body).to include(option.handle)
      end

      it 'renders page including body' do
        expect(response.body).to include(option.body.to_plain_text)
      end

      it 'renders page including created_at' do
        expect(response.body).to include(option.created_at.strftime('%B %d, %Y %H:%M'))
      end

      it 'renders page including updated_at' do
        expect(response.body).to include(option.updated_at.strftime('%B %d, %Y %H:%M'))
      end

      it 'renders the CRUD links for the options' do
        expect(response.body).to include('New Option')
        expect(response.body).to include('View')
        expect(response.body).to include('Edit')
        expect(response.body).to include('Delete')
      end
    end

    describe 'GET #new' do
      before { get :new }

      it 'renders the form with correct fields' do
        expect(response.body).to include('Title')
        expect(response.body).to include('Handle')
        expect(response.body).to include('option_body')
      end
    end

    describe 'GET #edit' do
      before { get :edit, params: { id: option.id } }

      it 'renders the form with correct fields populated' do
        expect(response.body).to include(option.title)
        expect(response.body).to include(option.handle)
        expect(response.body).to include(option.body.to_plain_text)
      end
    end

    describe 'GET #show' do
      before { get :show, params: { id: option.id } }

      it 'renders the form with correct fields populated' do
        expect(response.body).to include(option.title)
        expect(response.body).to include(option.handle)
        expect(response.body).to include(option.body.to_plain_text)
        expect(response.body).to include(option.created_at.strftime('%B %d, %Y %H:%M'))
        expect(response.body).to include(option.updated_at.strftime('%B %d, %Y %H:%M'))
      end
    end

    describe 'POST #create' do
      let(:option_params) { { title: 'Test Option', handle: 'test_option', body: 'Test Option Body' } }

      it 'creates a new option' do
        expect do
          post :create, params: { option: option_params }
        end.to change(Option, :count).by(1)
      end

      it 'redirects to the created option' do
        post :create, params: { option: option_params }
        test_option = Option.find_by(handle: 'test_option')
        expect(response).to redirect_to("/admin/options/#{test_option.id}")
      end

      context 'when handle is not unique' do
        let(:new_option_params) { { title: 'New Test Option', handle: 'about', body: 'New Test Option Body' } }

        it 'validates handle uniqueness' do
          post :create, params: { option: new_option_params }
          duplicate_option = Option.new(new_option_params)

          expect(duplicate_option).not_to be_valid
        end
      end
    end

    describe 'PATCH #update' do
      before { patch :update, params: { id: option.id, option: { title: 'Updated Option' } } }

      it 'updates the option with valid attributes' do
        option.reload
        expect(option.title).to eq('Updated Option')
      end

      it 'redirects to the option' do
        expect(response).to redirect_to(admin_option_url(option))
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the option' do
        expect do
          delete :destroy, params: { id: option.id }
        end.to change(Option, :count).by(-1)
      end

      it 'redirects to the options list' do
        delete :destroy, params: { id: option.id }
        expect(response).to redirect_to(admin_options_url)
      end
    end
  end
end
