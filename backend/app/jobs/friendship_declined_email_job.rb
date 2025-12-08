# frozen_string_literal: true

class FriendshipDeclinedEmailJob < ApplicationJob
  queue_as :default

  def perform(user, friendship_info)
    FriendshipMailer.with(user:).friendship_declined_email(friendship_info).deliver_now
  end
end
