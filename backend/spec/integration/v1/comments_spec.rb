# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/playlists/{id}/comments' do
  let(:user) { create(:user) }
  let(:playlist) { create(:playlist, playlist_type: 'public') }
  let(:Authorization) { "Bearer #{jwt_session_tokens[:access]}" }
  let(:playlist_id) { playlist.id }

  path '/api/v1/playlists/{playlist_id}/comments' do
    parameter name: 'playlist_id', in: :path, type: :string, required: true
    get('index comments') do
      parameter name: :page, in: :query, type: :integer, required: false
      tags 'Comments'
      response(200, 'OK') do
        let(:comment) { create(:comment, playlist:) }
        let(:page) { 1 }
        run_test!
      end

      response(200, 'OK') do
        let(:Authorization) { '' }
        run_test!
      end
    end

    post 'Creates a comment for a playlist' do
      tags 'Comments'
      security [bearerAuth: []]
      consumes 'application/json'
      parameter name: :comment_params, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string }
        },
        required: ['content']
      }

      response('201', 'created') do
        let!(:content) { 'This is a test comment.' }
        let(:comment_params) { { content: } }
        let!(:comment_new) { create(:comment, content:, user:, playlist:) }

        run_test! do
          data = JSON.parse(response.body)
          expect(data['data']['attributes']['content']).to eq(content)
          expect(data['data']['attributes']['user_name']).to eq(user.nickname)
          expect(Time.zone.parse(data['data']['attributes']['created_at']))
            .to be_within(1.second).of(Time.zone.parse(comment_new.created_at.to_s))
        end
      end

      response('422', 'Unprocessable Entity') do
        let(:comment_params) { { content: '' } }

        run_test! do |response|
          expect(response.code).to eq('422')
          json_response = JSON.parse(response.body)
          expect(json_response['errors']['details']['content']).to include("can't be blank")
          expect(json_response['errors']['details']['content']).to include('is too short (minimum is 10 characters)')
          expect(json_response['errors']['code']).to eq('validation_error')
        end
      end

      response('401', 'Unauthorized') do
        let(:Authorization) { '' }
        let(:comment_params) { { content: 'This is a test comment.' } }

        run_test!
      end
    end
  end
end
