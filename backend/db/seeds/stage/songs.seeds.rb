# frozen_string_literal: true

def unique_song_in_playlist(playlists, song_item)
  playlist = playlists.sample
  playlist = playlists.sample while PlaylistSong.exists?(playlist_id: playlist.id,
                                                         song_id: song_item.id)
  { playlist:, user_id: playlist.user_id }
end

def create_songs(num, album, genre)
  num.times do
    Song.create(
      title: FFaker::Music.song,
      album:,
      genre:,
      created_at: 1.year.ago,
      updated_at: 1.year.ago
    )
  end
end

after 'stage:albums', 'stage:artists', 'stage:genres', 'stage:playlists' do
  artists = Artist.all
  genres = Genre.all
  playlists = Playlist.all

  Album.find_each { |album| create_songs(rand(10..15), album, genres.sample) }

  cyrillic_songs = read_seeds_data('./db/seeds/data/songs_cyrillic.json')
  cyrillic_songs.each do |song|
    Song.create(
      title: song['title'], album: Album.find_or_create_by!(title: song['album']),
      genre: genres.sample,
      created_at: 1.year.ago, updated_at: 1.year.ago
    )
  end

  # Assign artists to songs. Put songs to playlists
  Song.find_each do |song|
    rand(1..3).times do
      artist = artists.sample
      ArtistSong.create(artist:, song:) unless ArtistSong.exists?(artist_id: artist.id, song_id: song.id)
    end

    rand(1..playlists.count).times do
      selected_playlist_data = unique_song_in_playlist(playlists, song)
      PlaylistSong.create(
        playlist: selected_playlist_data[:playlist],
        song:, user_id: selected_playlist_data[:user_id]
      )
    end
  end
end
