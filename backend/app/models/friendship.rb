# frozen_string_literal: true

class Friendship < ApplicationRecord
  enum status: {
    pending: 0,
    accepted: 1,
    declined: 2
  }, _suffix: true, _default: :pending

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  scope :with_sender, ->(sender) { where(sender_id: sender.id) }
  scope :with_receiver, ->(receiver) { where(receiver_id: receiver.id) }
  scope :with_sender_or_receiver, ->(user) { with_sender(user).or(with_receiver(user)) }
  scope :with_status, ->(status) { where(status:) }
end
