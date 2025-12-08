# frozen_string_literal: true

class SignInAttemptService
  MAX_ATTEMPTS = 5
  TIMEOUT = 60 * 5
  REDIS_KEY_PREFIX = 'login_attempts_'

  def initialize
    @redis = Redis.new
  end

  def check_login_attempts(email, user_id: nil)
    combined_key = combined_key(email, user_id)
    attempts = @redis.get(combined_key).to_i
    check_attempts(combined_key)
    attempts >= MAX_ATTEMPTS
  end

  def reset_login_attempts(user_id)
    email_keys = @redis.keys("#{REDIS_KEY_PREFIX}*_#{user_id}")
    email_keys.each do |key|
      @redis.del(key)
    end
  end

  private

  def combined_key(email, user_id)
    if user_id
      "#{REDIS_KEY_PREFIX}#{email}_#{user_id}"
    else
      REDIS_KEY_PREFIX + email
    end
  end

  def check_attempts(combined_key)
    @redis.incr(combined_key)
    @redis.expire(combined_key, TIMEOUT)
  end
end
