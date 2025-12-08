# frozen_string_literal: true

class UserForm
  include ActiveModel::Model

  PASSWORD_FORMAT = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*\W).{8,128}\z/
  PASSWORD_INVALID_CHARACTERS = /[\\'"\0]/
  NICKNAME_FORMAT = /\A(?!.*\s)(?=.{3,50}$)[a-zA-Z0-9]+.+[a-zA-Z0-9]+\Z/
  EMAIL_FORMAT = /\A[a-zA-Z0-9.!\#_-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])+\.[A-Za-z]+\z/

  attr_accessor :email, :nickname, :password

  validates :email, :nickname, :password, :password_confirmation, presence: true
  validates :email, format: { with: EMAIL_FORMAT }
  validates :email, email_domain: true
  validate :email_uniqueness

  validates :nickname, length: { minimum: 3, maximum: 50 }
  validates :nickname, format: { with: NICKNAME_FORMAT }
  validate :nickname_uniqueness

  validates :password, format: { with: PASSWORD_FORMAT }
  validates :password, format: { without: PASSWORD_INVALID_CHARACTERS }
  validates :password, length: { minimum: 8, maximum: 128 }
  validates :password, confirmation: true

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    User.create!(email:, nickname:, password:)
  end

  def email_uniqueness
    errors.add(:email, I18n.t('errors.uniqueness')) if User.exists?(email:)
  end

  def nickname_uniqueness
    errors.add(:nickname, I18n.t('errors.uniqueness')) if User.exists?(nickname:)
  end
end
