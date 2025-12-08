# frozen_string_literal: true

def create_playlists(num, user, created_at, playlist_type)
  num.times do
    description = [FFaker::Lorem.paragraph.truncate(50), FFaker::Lorem.paragraph.truncate(150), nil].sample
    Playlist.create(playlist_type:,
                    name: FFaker::Movie.title,
                    description:,
                    user:,
                    created_at:, updated_at: created_at,
                    featured: [true, false].sample,
                    logo_data: nil)
  end
end

after 'stage:users' do
  types = %i[open personal shared]

  User.find_each do |user|
    types.each do |type|
      create_playlists(4, user, 1.year.ago, type)
    end
  end
end
