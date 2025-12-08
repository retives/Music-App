# frozen_string_literal: true

class Playlist < ApplicationRecord
  include ImageUploader::Attachment(:logo)

  enum playlist_type: {
    personal: 'private', shared: 'shared', open: 'public'
  }, _suffix: true, _default: :personal

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :commentators, through: :comments, source: :user
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs
  has_many :reactions, dependent: :destroy
  has_many :liking_users, -> { where(reactions: { status: 1 }) }, through: :reactions, source: :user
  has_many :disliking_users, -> { where(reactions: { status: 0 }) }, through: :reactions, source: :user

  scope :public_playlists, -> { where(playlist_type: :open) }
  scope :shared_playlists, -> { where(playlist_type: :shared) }

  scope :all_user_related, lambda { |user|
    sent_friend_ids_sql = user.friendships_sent.where(status: 'accepted').select(:receiver_id).to_sql
    received_friend_ids_sql = user.friendships_received.where(status: 'accepted').select(:sender_id).to_sql
    friend_ids_sql = "SELECT * FROM (#{sent_friend_ids_sql} UNION ALL #{received_friend_ids_sql}) AS friend_ids"

    user_playlists_condition = 'user_id = ?'
    shared_playlists_condition = "user_id IN (#{friend_ids_sql}) AND playlist_type = ?"
    where("#{user_playlists_condition} OR #{shared_playlists_condition}", user.id, 'shared')
  }
end
