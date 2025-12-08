# frozen_string_literal: true

module TestHelpers
  def jwt_session_tokens
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload:, refresh_payload: payload)
    session.login
  end

  def jwt_session_tokens_for_specific_user(user)
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload:, refresh_payload: payload)
    session.login
  end

  def descending?(arr)
    is_descending = true
    arr.reduce do |l, r|
      break unless is_descending &= (l >= r)

      l
    end
    is_descending
  end
end
