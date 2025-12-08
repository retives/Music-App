# frozen_string_literal: true

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'get /users' do
    let!(:users) { create_list(:user, 7) }

    context 'when most popular' do
      before do
        create_list(:friendship, 5, receiver_id: users[0].id, status: 'accepted')
        create_list(:friendship, 4, receiver_id: users[1].id, status: 'accepted')
        create_list(:friendship, 3, receiver_id: users[2].id, status: 'accepted')
        create_list(:friendship, 2, receiver_id: users[3].id, status: 'accepted')
        create_list(:friendship, 1, receiver_id: users[4].id, status: 'accepted')

        get :index, params: { user_type: 'popular' }
      end

      it 'responds with ok status' do
        expect(response).to have_http_status :ok
      end

      it 'returns a list of most popular users' do
        expect(response.parsed_body['users']['data'].count).to eq(5)
      end

      it 'serializes the user profile_picture derivatives' do
        expect(response.body).to match(/"large":.*"medium":.*"small":.*"micro":/)
      end
    end

    context 'when top contributors' do
      before do
        create_list(:playlist, 5, user_id: users[0].id)
        create_list(:playlist, 4, user_id: users[1].id)
        create_list(:playlist, 3, user_id: users[2].id)
        create_list(:playlist, 2, user_id: users[3].id)
        create_list(:playlist, 1, user_id: users[4].id)

        get :index, params: { user_type: 'contributor' }
      end

      it 'responds with ok status' do
        expect(response).to have_http_status :ok
      end

      it 'returns a list of top contributors' do
        expect(response.parsed_body['users']['data'].count).to eq(5)
      end

      it 'serializes the user profile_picture derivatives' do
        expect(response.body).to match(/"large":.*"medium":.*"small":.*"micro":/)
      end
    end

    context 'when user type invalid' do
      before do
        get :index, params: { user_type: 'ivalid' }
      end

      it 'responds with bad request status' do
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'POST /users' do
    let(:user) { build(:user) }

    context 'when given valid params' do
      let(:user_attributes) { attributes_for(:user) }

      before do
        post :create, params: { user: attributes_for(:user) }
      end

      it 'responds with created status' do
        expect(response).to have_http_status :created
      end

      it 'returns an empty hash' do
        expect(response.parsed_body).to eql({})
      end

      it 'adds a new user to database' do
        expect { post(:create, params: { user: attributes_for(:user) }) }.to change(User, :count).by(1)
      end

      it 'calls UserReregistrationNotificationService' do
        allow(UserReregistrationNotificationService).to receive(:call)
        post :create, params: { user: user_attributes }
        expect(UserReregistrationNotificationService).to have_received(:call)
          .with(user_attributes[:email])
      end
    end

    context 'when given invalid params' do
      let(:user_attributes) { attributes_for(:user, nickname: '') }

      before do
        post :create, params: { user: attributes_for(:user, nickname: '') }
      end

      it 'responds with an error' do
        expect(response.body).to match_response_schema('errors', strict: true)
      end

      it 'does not add a new user to database' do
        expect { post(:create, params: { user: attributes_for(:user, nickname: '') }) }.not_to change(User, :count)
      end

      it 'does not call UserReregistrationNotificationService' do
        allow(UserReregistrationNotificationService).to receive(:call)
        post :create, params: { user: user_attributes }
        expect(UserReregistrationNotificationService).not_to have_received(:call)
          .with(user_attributes[:email])
      end
    end
  end
end
