# frozen_string_literal: true

RSpec.describe SignInAttemptService do
  describe 'check_login_attempts' do
    let(:user) { create(:user) }
    let(:redis) { Redis.new }
    let(:service) { described_class.new }

    context 'when login attempts are below the maximum limit' do
      it 'returns the false' do
        combined_key = "login_attempts_#{user.email}_#{user.id}"
        redis.set(combined_key, SignInAttemptService::MAX_ATTEMPTS - 1)
        result = service.check_login_attempts(user.email, user_id: user.id)

        expect(result).to be(false)
      end
    end

    context 'when login attempts reach the maximum limit' do
      it 'returns the true' do
        combined_key = "login_attempts_#{user.email}_#{user.id}"
        redis.set(combined_key, SignInAttemptService::MAX_ATTEMPTS)
        result = service.check_login_attempts(user.email, user_id: user.id)

        expect(result).to be(true)
      end
    end

    context 'when deleting login attempts for the given user_id' do
      let(:user_which_be_reseted) { create(:user) }
      let(:another_user) { create(:user) }

      before do
        redis.set("login_attempts_#{user_which_be_reseted.email}_#{user_which_be_reseted.id}", 4)
        redis.set("login_attempts_#{another_user.email}_#{another_user.id}", 4)

        service.reset_login_attempts(user_which_be_reseted.id)
      end

      it 'deletes login attempts for the user' do
        expect(redis.keys).not_to include("login_attempts_#{user_which_be_reseted.email}_#{user_which_be_reseted.id}")
      end

      it 'not affect another user' do
        expect(redis.keys).to include("login_attempts_#{another_user.email}_#{another_user.id}")
      end
    end

    context 'when user_id is nil' do
      let(:user_id) { nil }

      it 'reach combined_key method else case and return false' do
        result = service.check_login_attempts(user.email, user_id:)

        expect(result).to be(false)
      end

      it 'reach combined_key method else case and return true' do
        combined_key = "login_attempts_#{user.email}"
        redis.set(combined_key, SignInAttemptService::MAX_ATTEMPTS)
        result = service.check_login_attempts(user.email, user_id:)

        expect(result).to be(true)
      end
    end
  end
end
