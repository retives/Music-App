# frozen_string_literal: true

after 'stage:playlists', 'stage:users' do
  Playlist.find_each do |playlist|
    user_ids = User.pluck(:id).shuffle

    rand(1..10).times do
      user_id = user_ids.pop
      Reaction.create(playlist_id: playlist.id, user_id:, status: rand(0..1))
    end
  end
end
