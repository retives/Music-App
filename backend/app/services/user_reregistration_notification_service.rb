# frozen_string_literal: true

class UserReregistrationNotificationService < ApplicationService
  def initialize(user_email)
    @user_email = user_email
  end

  def call
    re_registered_user = DeletedUserDatum.find_by(user_email: @user_email)
    return if re_registered_user.blank?

    friend_ids = re_registered_user.friends_ids&.[](1..-2)&.split(', ')
    re_registered_user.destroy
    return if friend_ids.blank?

    user = User.find_by(email: @user_email)
    friend_ids.map(&:to_i).each do |friend_id|
      FriendshipReconnectEmailJob.perform_later(user, friend_id)
    end
  end
end
