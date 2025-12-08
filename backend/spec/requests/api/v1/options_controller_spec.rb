# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OptionsController, type: :controller do
  let(:option) { create(:option) }

  describe 'GET #show' do
    context 'when requesting an existent option' do
      before { get :show, params: { handle: option[:handle] } }

      it 'returns the option data by handle' do
        data = response.parsed_body['option']['data']

        expect(response).to have_http_status(:ok)
        expect(data['type']).to eq('option')
        expect(data['attributes']['title']).to eq(option[:title])
        expect(data['attributes']['body']['body']).to eq(option.body.to_plain_text)
      end
    end

    context 'when requesting a non-existent option' do
      before { get :show, params: { handle: 'non_existent' } }

      it 'returns not_found status' do
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['errors']).to eq(I18n.t('errors.data_not_found'))
      end
    end
  end
end
