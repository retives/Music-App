# frozen_string_literal: true

AdminUser.find_or_create_by!(email: 'superadmin@example.com') do |admin_user|
  admin_user.nickname = 'Superadmin'
  admin_user.password = Rails.application.credentials.superadmin_password
  admin_user.password_confirmation = Rails.application.credentials.superadmin_password
end
