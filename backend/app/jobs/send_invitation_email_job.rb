# frozen_string_literal: true

class SendInvitationEmailJob < ApplicationJob
  queue_as :default

  def perform(user, email)
    app_receiver = User.find_by(email:)
    if app_receiver
      friendship = Friendship.find_by(sender: user, receiver: app_receiver)
      token = FriendshipTokenService.new.generate_token(friendship.id)
      FriendshipMailer.with(user:).friend_request_email(friendship, token).deliver_now
    else
      FriendshipMailer.with(user:).invitation_email(email).deliver_now
    end
  end
end
