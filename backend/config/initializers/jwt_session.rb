# frozen_string_literal: true

JWTSessions.token_store = :redis
JWTSessions.algorithm = 'HS256'
JWTSessions.signing_key = Rails.application.credentials.secret_jwt_signing_key || ENV.fetch('secret_jwt_signing_key')
JWTSessions.refresh_exp_time = 60 * 60 * 24 * 365
