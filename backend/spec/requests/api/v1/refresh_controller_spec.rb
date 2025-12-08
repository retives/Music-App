# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RefreshController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST /refresh' do
    context 'when token refresh is successful' do
      let(:refresh_token) { "Bearer #{jwt_session_tokens[:refresh]}" }

      before do
        request.headers[JWTSessions.refresh_header] = refresh_token
        post :create
      end

      it 'request succeeded' do
        expect(response).to be_successful
      end

      it 'returns set of tokens' do
        expect(response.parsed_body.keys.sort).to eq %w[access access_expires_at csrf]
      end
    end

    context 'when token refresh failed' do
      it 'tokens are absent' do
        post :create
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
