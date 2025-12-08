# frozen_string_literal: true

class FriendshipTokenService
  TIMEOUT_DAYS = 7
  REDIS_KEY_PREFIX = 'friendship_token:'

  def initialize
    @redis = Redis.new
  end

  def generate_token(friendship_id)
    token = SecureRandom.hex(32)
    @redis.set(redis_key_for_token(token), friendship_id)
    @redis.expire(redis_key_for_token(token), TIMEOUT_DAYS.days.to_i)
    token
  end

  def handle_token_confirmation(user:, token:, friendship:)
    friendship_id = find_friendship_by_token(token).to_i
    if friendship.id == friendship_id
      process_friendship_direction(user:, token:, friendship:)
    else
      { errors: I18n.t('errors.invalid_token'), status: :unprocessable_entity }
    end
  end

  private

  def redis_key_for_token(token)
    "#{REDIS_KEY_PREFIX}#{token}"
  end

  def delete_token(token)
    @redis.del(redis_key_for_token(token))
  end

  def find_friendship_by_token(token)
    @redis.get(redis_key_for_token(token))
  end

  def process_friendship_direction(user:, token:, friendship:)
    if friendship.receiver == user
      delete_token(token)
      { message: I18n.t('info.friendship_status_changed'),
        friendship: Api::V1::FriendshipSerializer.new(friendship, {}).serializable_hash,
        status: :ok }
    else
      { errors: I18n.t('errors.not_receiver'),
        status: :unprocessable_entity }
    end
  end
end
