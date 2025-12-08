# frozen_string_literal: true

class ApiController < ActionController::API
  include Pundit::Authorization
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :render_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from Pundit::NotAuthorizedError, with: :render_pundit_not_authorized_error

  DEFAULT_TIMEZONE = 'Kyiv'
  LOCALHOST = '127.0.0.1'

  private

  def check_for_authorization_header
    return unless request.headers.include? 'Authorization'

    authorize_access_request!
  end

  def current_user
    return unless request.headers.include? 'Authorization'

    @current_user ||= begin
      user = User.find(payload['user_id'])
      user.timezone = find_timezone
      user.save
      Time.zone = user.timezone
      user
    end
  end

  def create_access_payload(user)
    {
      user_id: user.id,
      user_email: user.email,
      user_nickname: user.nickname,
      user_picture: user.profile_picture_data
    }
  end

  def render_errors(exception, status)
    render json: { errors: exception }, status:
  end

  def render_not_found(exception)
    render_errors(exception, :not_found)
  end

  def render_unprocessable_entity(exception)
    render_errors(exception, :unprocessable_entity)
  end

  def render_not_authorized(exception)
    render_errors(exception, :unauthorized)
  end

  def render_pundit_not_authorized_error(exception)
    policy_name = exception.policy.class.to_s.underscore

    render_errors(I18n.t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default),
                  current_user.nil? ? :unauthorized : :forbidden)
  end

  def delete_current_session
    session = JWTSessions::Session.new(payload:, refresh_by_access_allowed: true)
    session.flush_by_access_payload
  end

  def serialization_options(includes)
    return {} if includes.blank?

    { include: includes.split(',').map(&:to_sym) }
  end

  def remote_ip
    request.remote_ip if request.remote_ip != LOCALHOST
  end

  def find_timezone
    results = Geocoder.search(remote_ip.to_s)

    if results.present? && results.first.data.present? && results.first.data.key?('timezone')
      results.first.data['timezone']
    else
      DEFAULT_TIMEZONE
    end
  end
end
