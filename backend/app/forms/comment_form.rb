# frozen_string_literal: true

class CommentForm
  include ActiveModel::Model

  TIME_THRESHOLD = 1.minute
  MAX_COMMENTS_COUNT = 3
  MIN_COMMENT_LENGTH = 10
  MAX_COMMENT_LENGTH = 1000

  attr_accessor :content, :comment
  attr_reader :user, :playlist

  validates :content, presence: true
  validates :content, length: { minimum: MIN_COMMENT_LENGTH, maximum: MAX_COMMENT_LENGTH }

  validate :limit_threshold

  def initialize(user, playlist, content)
    @user = user
    @playlist = playlist
    self.content = content
  end

  def save
    return false unless valid?

    persist!
    true
  end

  private

  def persist!
    self.comment = Comment.create!(playlist_id: playlist.id, user_id: user.id, content:)
  end

  def limit_threshold
    time_box = Time.zone.now - TIME_THRESHOLD
    comments_available = user.comments.where('created_at > ?', time_box).count < MAX_COMMENTS_COUNT
    return if comments_available

    errors.add(:base,
               I18n.t('errors.too_many_comments', max_comment_count: MAX_COMMENTS_COUNT,
                                                  time_threshold: TIME_THRESHOLD))
  end
end
