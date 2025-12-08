# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :controller do
  render_views

  context 'when logged in as admin' do
    let(:admin) { create(:admin_user) }

    before { sign_in(admin) }

    it 'renders admin users list' do
      get :index

      expect(response.body).to include(admin.email)
    end

    it 'renders new admin user form' do
      get :new

      expect(response.body).to include('New Admin User')
    end
  end
end
