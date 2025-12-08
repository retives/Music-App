# frozen_string_literal: true

class FriendshipForm
  include ActiveModel::Model

  attr_accessor :current_user, :email

  validates :current_user, :email, presence: true
  validate :validate_user_exists
  validate :validate_not_self
  validate :friendship_uniqueness

  def initialize(current_user, email)
    @current_user = current_user
    @email = email
    @receiver = User.find_by(email:)
  end

  def save
    return false if invalid?

    persist!
  end

  private

  def persist!
    Friendship.create(sender: @current_user, receiver: @receiver)
  end

  def validate_user_exists
    errors.add(:email, I18n.t('errors.user_not_exist')) if @receiver.blank?
  end

  def validate_not_self
    errors.add(:email, I18n.t('errors.your_email')) if @current_user&.email == @email
  end

  def friendship_uniqueness
    if friendship_exists?(:accepted)
      errors.add(:email, I18n.t('errors.accepted_friendship_exists'))
    elsif friendship_exists?(:pending)
      errors.add(:email, I18n.t('errors.pending_friendship_exists'))
    end
  end

  def friendship_exists?(status)
    Friendship.with_status(status).where(sender: @current_user,
                                         receiver: @receiver).or(Friendship.with_status(status).where(
                                                                   sender: @receiver, receiver: @current_user
                                                                 )).exists?
  end
end
