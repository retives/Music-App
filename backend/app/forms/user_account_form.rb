# frozen_string_literal: true

class UserAccountForm
  include ActiveModel::Model
  MIN_NICKNAME_LENGTH = 3
  MAX_NICKNAME_LENGTH = 50

  NICKNAME_FORMAT = /\A(?!.*\s)(?=.{3,50}$)[a-zA-Z0-9]+.+[a-zA-Z0-9]+\Z/
  EMAIL_FORMAT = /\A[a-zA-Z0-9.!\#_-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])+\.[A-Za-z]+\z/

  attr_accessor :email, :nickname, :profile_picture

  validates :email, format: { with: EMAIL_FORMAT },
                    email_domain: true,
                    if: :email_present?
  validate :email_uniqueness

  validates :nickname, length: { minimum: MIN_NICKNAME_LENGTH, maximum: MAX_NICKNAME_LENGTH },
                       format: { with: NICKNAME_FORMAT },
                       if: :nickname_present?
  validate :nickname_uniqueness

  validate :profile_picture_shrine_validation

  def initialize(user, attributes = {})
    @user = user
    update_form_values(attributes)
  end

  def update
    return false if invalid?

    update_user!
    delete_previous_pictures(@previous_images) if @previous_images.present?
    true
  end

  private

  def update_form_values(attributes)
    self.email = attributes[:email].presence
    self.nickname = attributes[:nickname].presence
    self.profile_picture = attributes[:profile_picture].presence
  end

  def update_user!
    updates = {
      email: email || @user.email,
      nickname: nickname || @user.nickname,
      profile_picture:
    }
    updates = updates.compact if (email_present? || nickname_present?) && profile_picture.blank?
    @user.update!(updates)
  end

  def email_uniqueness
    return unless email_present?

    existing_user = User.find_by(email:)
    return unless existing_user && existing_user.id != @user.id

    errors.add(:email, I18n.t('errors.uniqueness'))
  end

  def nickname_uniqueness
    return unless nickname_present?

    existing_user = User.find_by(nickname:)
    return unless existing_user && existing_user.id != @user.id

    errors.add(:nickname, I18n.t('errors.uniqueness'))
  end

  def email_present?
    email.present?
  end

  def nickname_present?
    nickname.present?
  end

  def profile_picture_shrine_validation
    return if profile_picture.blank?

    shrine_attacher ||= UserImageUploader::Attacher.from_model(@user, :profile_picture)
    @previous_images = get_previous_images(shrine_attacher)
    shrine_attacher.assign(profile_picture)

    if shrine_attacher.errors.empty?
      profile_picture.open
    else
      shrine_attacher.errors.each { |error| errors.add(:profile_picture, error) }
    end
  end

  def get_previous_images(shrine_attacher)
    shrine_attacher.derivatives.merge(file: shrine_attacher.file)
  end

  def delete_previous_pictures(previous)
    return unless previous || previous[:file]&.exists?

    previous.each_value { |image| image&.delete if image&.exists? }
  end
end
