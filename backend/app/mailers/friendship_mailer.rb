# frozen_string_literal: true

class FriendshipMailer < ApplicationMailer
  MY_FRIENDS_PAGE_URL = 'http://localhost:3000/api/v1/my/friendships'

  def invitation_email(email)
    @user = params[:user]
    @email = params[:email]
    @url = 'http://google.com'
    mail(to: email, subject: I18n.t('mailer.invitation_email_subject', app_name: ApplicationMailer::APP_NAME))
  end

  def friendship_confirmation_email(friendship)
    @friendship = friendship
    mail(to: @friendship.sender.email,
         subject: I18n.t('mailer.accept_email_subject', app_name: ApplicationMailer::APP_NAME))
  end

  def friendship_declined_email(friendship_info)
    @sender_nickname = friendship_info[:sender_nickname]
    @receiver_nickname = friendship_info[:receiver_nickname]
    @sender_timezone = friendship_info[:sender_timezone]
    @url = 'http://google.com'
    mail(to: friendship_info[:email],
         subject: I18n.t('mailer.declined_email_subject', app_name: ApplicationMailer::APP_NAME))
  end

  def friend_request_email(friendship, token)
    @friendship = friendship
    @url = MY_FRIENDS_PAGE_URL
    @accept_url = "#{MY_FRIENDS_PAGE_URL}/#{@friendship.id}?status=accept&token=#{token}"
    @decline_url = "#{MY_FRIENDS_PAGE_URL}/#{@friendship.id}?status=decline&token=#{token}"
    mail(to: @friendship.receiver.email,
         subject: I18n.t('mailer.new_friend_request_email_subject', app_name: ApplicationMailer::APP_NAME))
  end

  def reconnect_invitation_email(user, friend)
    @user = user
    @friend = friend
    @url = 'http://google.com'
    mail(to: @friend.email,
         subject: I18n.t('mailer.reconnection_invitation_email_subject',
                         app_name: ApplicationMailer::APP_NAME))
  end
end
