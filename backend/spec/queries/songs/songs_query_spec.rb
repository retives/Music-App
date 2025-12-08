# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Songs::SongsQuery, type: :query do
  describe '#call' do
    subject(:songs_query) { described_class.new(Playlist.all.max_by { |playlist| playlist.songs.count }) }

    let!(:sort_type) { 'popularity' }
    let!(:songs) { create_list(:song, 3) }
    let!(:playlists) do
      create_list(:playlist, 4, playlist_type: 'public')
    end

    before do
      [
        create(:playlist_song, playlist: playlists[0], song: songs[0]),
        create(:playlist_song, playlist: playlists[0], song: songs[1]),

        create(:playlist_song, playlist: playlists[1], song: songs[1]),
        create(:playlist_song, playlist: playlists[1], song: songs[2]),

        create(:playlist_song, playlist: playlists[2], song: songs[1]),
        create(:playlist_song, playlist: playlists[2], song: songs[2]),

        create(:playlist_song, playlist: playlists[3], song: songs[0]),
        create(:playlist_song, playlist: playlists[3], song: songs[1]),
        create(:playlist_song, playlist: playlists[3], song: songs[2])
      ]
    end

    context 'with sort_type: "popularity" and sort_direction: "asc"' do
      let!(:sort_direction) { 'asc' }

      it 'returns songs sorted by popularity in ascending order' do
        sorted_songs = songs_query.call(sort_type, sort_direction)

        expect(sorted_songs).to eq([songs[0], songs[2], songs[1]])
      end
    end

    context 'with sort_type: "popularity" and sort_direction: "desc"' do
      let!(:sort_direction) { 'desc' }

      it 'returns songs sorted by popularity in descending order' do
        sorted_songs = songs_query.call(sort_type, sort_direction)

        expect(sorted_songs).to eq([songs[1], songs[2], songs[0]])
      end
    end
  end
end
