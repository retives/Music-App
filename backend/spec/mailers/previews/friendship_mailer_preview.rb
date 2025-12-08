# frozen_string_literal: true

class FriendshipMailerPreview < ActionMailer::Preview
  def invitation_email
    email = 'example_email@example.com'
    FriendshipMailer.with(user: User.first).invitation_email(email)
  end

  def friendship_confirmation_email
    sender = User.first
    receiver = User.second
    friendship = Friendship.new(sender:, receiver:, updated_at: Time.current)
    FriendshipMailer.with(user: sender).friendship_confirmation_email(friendship)
  end

  def friendship_declined_email
    friendship = Friendship.new(sender: User.first, receiver: User.second)

    friendship_info = {
      sender_nickname: friendship.sender.nickname,
      receiver_nickname: friendship.receiver.nickname,
      sender_timezone: friendship.sender.timezone,
      email: friendship.sender.email
    }
    FriendshipMailer.with(user: User.first).friendship_declined_email(friendship_info)
  end

  def friend_request_email
    sender = User.first
    receiver = User.second
    friendship = Friendship.new(sender:, receiver:, created_at: Time.current)
    token = FriendshipTokenService.new.generate_token(friendship.id)
    FriendshipMailer.with(user: User.first).friend_request_email(friendship, token)
  end

  def reconnect_invitation_email
    user = User.first
    friend = User.second
    FriendshipMailer.with(user: User.first).reconnect_invitation_email(user, friend)
  end
end
