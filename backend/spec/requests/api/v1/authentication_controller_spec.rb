# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST /login' do
    context 'when login is successful' do
      before { post :create, params: { email: user.email, password: user.password } }

      it 'request succeeded' do
        expect(response).to be_successful
      end

      it 'returns set of tokens' do
        expect(response.parsed_body.keys.sort).to eq %w[access access_expires_at csrf refresh refresh_expires_at]
      end
    end

    context 'when user authentication failed' do
      before { post :create, params: { email: user.email, password: 'abcd' } }

      it 'request unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns failure message' do
        expect(response.body).to eq({ errors: I18n.t('errors.authorization') }.to_json)
      end
    end

    context 'when there are too many login attempts' do
      let(:service_double) { instance_double(SignInAttemptService) }

      before do
        allow(User).to receive(:find_by).and_return(user)
        allow(SignInAttemptService).to receive(:new).and_return(service_double)
        allow(service_double).to receive(:check_login_attempts).and_return(true)
      end

      it 'has status unauthorized' do
        post :create, params: { email: user.email, password: user.password }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders the too many attempts error' do
        post :create, params: { email: user.email, password: user.password }
        expect(response.body).to include(I18n.t('errors.too_many_attempts'))
      end
    end
  end

  describe 'DELETE /logout' do
    let(:session) do
      payload = { user_id: user.id }
      JWTSessions::Session.new(payload:, refresh_by_access_allowed: true)
    end
    let(:tokens) { session.login }

    context 'when success logout' do
      before do
        request.headers[JWTSessions.access_header] = "Bearer #{tokens[:access]}"
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]
      end

      it 'returns http success' do
        delete :destroy
        expect(response).to have_http_status(:ok)
      end

      it 'returns http success after refresh' do
        request.headers[JWTSessions.access_header] = "Bearer #{session.refresh_by_access_payload[:access]}"
        delete :destroy
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unsuccess logout' do
      it 'returns http status unauthorized without auth' do
        delete :destroy
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns http status unauthorized with invalid access token' do
        request.headers[JWTSessions.access_header] = 'Bearer invalid acsses token'
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]
        delete :destroy
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
