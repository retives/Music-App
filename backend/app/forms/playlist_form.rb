# frozen_string_literal: true

class PlaylistForm
  include ActiveModel::Model

  attr_accessor :playlist_type, :name, :logo, :description
  attr_reader :playlist

  validates :name, presence: true
  validates :name, length: { minimum: 3, maximum: 50 }
  validates :description, length: { minimum: 3, maximum: 1000 }, allow_nil: true
  validates :playlist_type, inclusion: { in: Playlist.playlist_types.values }

  def initialize(user, attributes = {})
    if attributes[:id].nil?
      attributes[:description] = attributes[:description].presence
      super(attributes)
    else
      @playlist = Playlist.find(attributes[:id])
      update_form_values(attributes)
    end
    self.playlist_type ||= Playlist.playlist_types[:personal]
    @user = user
  end

  def save
    return false unless valid?

    persist!
    true
  end

  def update
    return false unless valid?

    update_playlist!
    true
  end

  private

  def persist!
    @playlist = Playlist.create!(playlist_type:, name:, logo:, description:, user: @user)
  end

  def update_form_values(attributes)
    self.name = attributes[:name]
    self.logo = attributes[:logo].presence
    logo.open if logo.present?
    self.description = (attributes[:description].presence)
  end

  def update_playlist!
    @playlist.update!(name:, logo:, description:)
  end
end
