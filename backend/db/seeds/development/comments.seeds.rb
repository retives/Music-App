# frozen_string_literal: true

last_year = 1.year.ago..Time.zone.now

after 'development:playlists', 'development:users' do
  Playlist.find_each do |playlist|
    next if playlist.playlist_type == 'private'

    User.all.sample(50).each do |user|
      # commentable = [Album, Artist, Playlist, Song].sample.all.sample
      # commentable.comments.create(body: FFaker::Lorem.paragraph, user: user)
      rand(0..2).times do
        Comment.create(
          content: FFaker::Lorem.sentence,
          user:,
          playlist:,
          created_at: rand(last_year)
        )
      end
    end
  end
end
