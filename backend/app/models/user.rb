# frozen_string_literal: true

class User < ApplicationRecord
  include UserImageUploader::Attachment(:profile_picture)

  has_secure_password :password, validations: false
  # self.ignored_columns = ['password']

  has_many :playlists, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :reactions, dependent: :nullify
  has_many :liked_playlists, -> { where(reactions: { status: 1 }) }, through: :reactions, source: :playlist
  has_many :disliked_playlists, -> { where(reactions: { status: 0 }) }, through: :reactions, source: :playlist
  has_many :playlist_songs, dependent: :nullify

  def friendships
    Friendship.where('sender_id = ? OR receiver_id = ?', id, id)
  end

  has_many :friendships_sent,
           class_name: 'Friendship', inverse_of: :sender, foreign_key: 'sender_id', dependent: :destroy
  has_many :friendships_received,
           class_name: 'Friendship', inverse_of: :receiver, foreign_key: 'receiver_id', dependent: :destroy

  scope :with_friends, (lambda {
    join_condition = <<-SQL.squish
      LEFT OUTER JOIN friendships AS f ON
        ((users.id = f.sender_id OR users.id = f.receiver_id) AND
        f.status = #{Friendship.statuses[:accepted]})
    SQL

    joins(join_condition)
      .group('users.id')
      .select('users.*, COUNT(DISTINCT f.id) AS friends_count')
  })

  def friends_count
    attributes['friends_count']
  end
end
