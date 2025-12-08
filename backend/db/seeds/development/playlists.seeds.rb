# frozen_string_literal: true

def attach_playlist_logo(playlist)
  first_playlist_with_logo = Playlist.where.not(logo_data: nil).first
  if first_playlist_with_logo.present?
    logo = [first_playlist_with_logo.logo_data, nil].sample
    playlist.update(logo_data: logo)
  else
    image_file = Rails.public_path.join('uploads', 'default_image.jpg').open('rb')
    playlist.logo = image_file
    playlist.logo_derivatives! if playlist.logo.present?
    playlist.save
  end
end

def create_playlists(num, user, created_at, playlist_type)
  num.times do
    description = [FFaker::Lorem.paragraph.truncate(50), FFaker::Lorem.paragraph.truncate(150), nil].sample
    featured = [true, false].sample
    playlist = Playlist.new(playlist_type:,
                            name: FFaker::Movie.title,
                            description:,
                            user:,
                            created_at:,
                            updated_at: created_at,
                            featured:)
    attach_playlist_logo(playlist)
  end
end

after 'development:users' do
  types = %i[open personal shared]

  User.find_each do |user|
    types.each do |type|
      create_playlists(4, user, 1.year.ago, type)
    end
  end
end
