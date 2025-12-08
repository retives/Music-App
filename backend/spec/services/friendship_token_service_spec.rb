# frozen_string_literal: true

RSpec.describe FriendshipTokenService do
  let(:service) { described_class.new }
  let(:user) { create(:user) }
  let(:friendship) { create(:friendship, receiver: user, status: :pending) }
  let(:redis) { Redis.new }
  let!(:token) { service.generate_token(friendship.id) }

  describe '#generate_token' do
    it 'saves token into the redis' do
      expect(redis.keys).to include(FriendshipTokenService::REDIS_KEY_PREFIX + token)
    end

    it 'sets timeout for token' do
      ttl = redis.ttl("#{FriendshipTokenService::REDIS_KEY_PREFIX}#{token}")
      expect(ttl).to be <= FriendshipTokenService::TIMEOUT_DAYS.days.to_i
    end

    it 'generates a token as a string' do
      expect(token).to be_a(String)
    end

    it 'generates a token with apropriate length' do
      expect(token.length).to eq(64)
    end
  end

  describe '#handle_token_confirmation' do
    context 'when valid token is provided' do
      context 'when token equal friendship id and user is receiver' do
        it 'returns the appropriate response' do
          expect(service.handle_token_confirmation(user:, token:, friendship:)).to include(
            message: I18n.t('info.friendship_status_changed'),
            friendship: be_a(Hash),
            status: :ok
          )
        end

        it 'deletes token from Redis' do
          service.handle_token_confirmation(user:, token:, friendship:)
          expect(redis.keys).not_to include(FriendshipTokenService::REDIS_KEY_PREFIX + token)
        end
      end

      context 'when token equal friendship id and user is sender' do
        let(:friendship) { create(:friendship, sender: user, receiver: create(:user), status: :pending) }

        it 'returns the appropriate response' do
          expect(service.handle_token_confirmation(user:, token:, friendship:)).to include(
            errors: I18n.t('errors.not_receiver'),
            status: :unprocessable_entity
          )
        end

        it 'keeps token in Redis' do
          service.handle_token_confirmation(user:, token:, friendship:)
          expect(redis.keys).to include(FriendshipTokenService::REDIS_KEY_PREFIX + token)
        end
      end
    end

    context 'when invalid token is provided' do
      let(:token) { 'invalid token' }

      it 'returns the error message for invalid token' do
        result = service.handle_token_confirmation(user:, token:, friendship:)
        expect(result).to eq({ errors: I18n.t('errors.invalid_token'), status: :unprocessable_entity })
      end
    end
  end
end
