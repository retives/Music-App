# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  APP_NAME = 'Music App'
  default from: 'from@example.com'
  layout 'mailer'
end
