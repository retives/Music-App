# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  describe 'error handling' do
    context 'when raising Record not found error' do
      controller do
        def create
          raise ActiveRecord::RecordNotFound
        end
      end

      it 'renders a not found response' do
        get :create
        expect(response.body).to eq({ errors: ActiveRecord::RecordNotFound }.to_json)
      end

      it 'return a not found code' do
        get :create
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'when raising Record invalid error' do
    controller do
      def create
        raise ActiveRecord::RecordInvalid, User.new
      end
    end

    it 'renders an unprocessable entity response' do
      get :create
      expect(response.body).to eq({ errors: 'Validation failed: ' }.to_json)
    end

    it 'return unprocessable entity code' do
      get :create
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe '#remote_ip' do
    context 'when remote_ip is 127.0.0.1' do
      before do
        allow(request).to receive(:remote_ip).and_return('127.0.0.1')
      end

      it 'returns a nil' do
        expect(controller.send(:remote_ip)).to be_nil
      end
    end

    context 'when remote_ip is not 127.0.0.1' do
      before do
        allow(request).to receive(:remote_ip).and_return('192.168.1.1')
      end

      it 'returns the actual remote IP address' do
        expect(controller.send(:remote_ip)).to eq('192.168.1.1')
      end
    end
  end

  describe '#find_timezone' do
    context 'when Geocoder returns a timezone' do
      before do
        allow(controller).to receive(:remote_ip).and_return('8.8.8.8')
        allow(Geocoder).to receive(:search).with('8.8.8.8')
          .and_return(Geocoder.search(controller.send(:remote_ip)))
      end

      it 'returns the correct timezone' do
        expect(controller.send(:find_timezone)).to eq('America/Los_Angeles')
      end
    end

    context 'when Geocoder does not return a timezone' do
      before do
        allow(controller).to receive(:remote_ip).and_return('8.8.8.8')
        allow(Geocoder).to receive(:search).and_return([])
      end

      it 'returns a default timezone (Kyiv in this case)' do
        expect(controller.send(:find_timezone)).to eq('Kyiv')
      end
    end
  end
end
