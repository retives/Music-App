# frozen_string_literal: true

module FactoryHelpers
  # Adds genres to songs on creation
  #
  # @param [Integer] songs_count
  # @param [Integer] genres_count
  # @return [void]
  def setup_songs_with_genres(songs_count = 24, genres_count = 8)
    genres = create_list(:genre, genres_count)
    genres_ids = genres.map(&:id)
    songs_count.times { create(:song, genre_id: genres_ids.sample) }
  end

  # Creates songs and playlists, then puts songs into playlists randomly
  #
  # @param [Integer] songs_count
  # @param [Integer] playlists_count
  # @return [void]
  #
  def setup_playlist_songs(songs_count = 24, playlists_count = 6)
    songs = Song.all.empty? ? create_list(:song, songs_count) : Song.all
    playlists = create_list(:playlist, playlists_count, playlist_type: %w[public private].sample)
    playlists_ids = playlists.map(&:id)

    songs.each do |song|
      rand(1..playlists_count).times do
        create(:playlist_song, song_id: song.id, playlist_id: playlists_ids.sample)
      rescue StandardError
        next
      end
    end
  end

  # Counts how many times each song from the given collection occurs in playlists
  #
  # @param [Array<Song>] songs
  # @return [Array<Integer>]
  def song_occurrences_in_playlists(songs)
    songs.map { |song| PlaylistSong.by_song_id(song['id']).count }
  end

  def setup_friendship(current_user)
    senders = create_list(:user, 3)
    receivers = create_list(:user, 3)
    friend_senders = create_list(:user, 5)
    friend_receivers = create_list(:user, 5)

    sender_friendships(senders, current_user, 'pending')
    receiver_friendships(receivers, current_user, 'pending')
    sender_friendships(friend_senders, current_user, 'accepted')
    receiver_friendships(friend_receivers, current_user, 'accepted')
  end

  def sender_friendships(senders, current_user, status)
    senders.each do |sender|
      create(:friendship, sender_id: sender.id, receiver_id: current_user.id, status:)
    end
  end

  def receiver_friendships(receivers, current_user, status)
    receivers.each do |receiver|
      create(:friendship, sender_id: current_user.id, receiver_id: receiver.id, status:)
    end
  end
end
