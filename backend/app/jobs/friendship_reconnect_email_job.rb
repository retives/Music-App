# frozen_string_literal: true

class FriendshipReconnectEmailJob < ApplicationJob
  queue_as :default

  def perform(user, friend_id)
    friend = User.find_by(id: friend_id)
    FriendshipMailer.with(user:).reconnect_invitation_email(user, friend).deliver_now if friend
  end
end
