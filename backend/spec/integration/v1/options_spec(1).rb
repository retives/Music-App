# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/options/{handle}' do
  let(:option) { create(:option) }

  path '/api/v1/options/{handle}' do
    get('Lists a option data') do
      tags 'Options'
      produces 'application/json'

      parameter name: :handle, in: :path, type: :string, required: true, example: :about,
                description: 'Returns the option data by its handle (e.g. `about`)'

      response(200, 'Option found') do
        let(:handle) { option['handle'] }

        include_context 'with integration test'
      end

      response(404, 'Option not found') do
        let(:handle) { 'non_existent' }

        include_context 'with integration test'
      end
    end
  end
end
