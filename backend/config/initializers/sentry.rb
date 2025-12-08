# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = Rails.application.credentials&.sentry_dsn&.[](:first_dsn)
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.traces_sample_rate = 1.0

  config.traces_sampler = lambda do |_context|
    true
  end

  config.excluded_exceptions += ['JWTSessions::Errors::Unauthorized',
                                 'ActiveRecord::RecordNotFound',
                                 'ActiveRecord::RecordInvalid',
                                 'Pundit::NotAuthorizedError']

  config.before_send = lambda do |event, hint|
    exception = hint[:exception]

    if exception.is_a?(StandardError)
      current_hub = Sentry.get_current_hub
      _first_dsn, *rest_dsns = Rails.application.credentials&.sentry_dsn&.values || []

      rest_dsns.each do |dsn|
        hub = current_hub.clone
        hub.bind_client(Sentry::Client.new(Sentry.configuration.clone.tap { |c| c.dsn = dsn }))

        cloned_breadcrumbs = event.breadcrumbs.buffer.compact

        cloned_breadcrumbs.each do |breadcrumb|
          hub.add_breadcrumb(
            Sentry::Breadcrumb.new(
              category: breadcrumb.category,
              message: breadcrumb.message,
              level: breadcrumb.level,
              timestamp: breadcrumb.timestamp,
              data: breadcrumb.data
            )
          )
        end
        hub.capture_message(exception.message)
      end
      current_hub.capture_exception(exception)
    end

    event
  end
end
