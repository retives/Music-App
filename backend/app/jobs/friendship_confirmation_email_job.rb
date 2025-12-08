# frozen_string_literal: true

class FriendshipConfirmationEmailJob < ApplicationJob
  queue_as :default

  def perform(user, friendship)
    FriendshipMailer.with(user:).friendship_confirmation_email(friendship).deliver_now
  end
end
