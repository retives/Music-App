# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Songs::PopularSongsQuery, type: :query do
  describe '#call' do
    subject(:ordered_songs) { described_class.call(Song.all) }

    let(:songs) do
      create_list(:song, 7) do |song, index|
        song.created_at = Time.current - index.days
        song.save
      end
    end

    let(:playlists) { create_list(:playlist, 4, playlist_type: 'private') }

    before do
      playlist_songs_data = [
        { playlist: playlists[0], song: songs[4] },

        { playlist: playlists[1], song: songs[4] },
        { playlist: playlists[1], song: songs[3] },

        { playlist: playlists[2], song: songs[4] },
        { playlist: playlists[2], song: songs[3] },
        { playlist: playlists[2], song: songs[2] },

        { playlist: playlists[3], song: songs[4] },
        { playlist: playlists[3], song: songs[3] },
        { playlist: playlists[3], song: songs[2] },
        { playlist: playlists[3], song: songs[1] },
        { playlist: playlists[3], song: songs[0] },
        { playlist: playlists[3], song: songs[5] },
        { playlist: playlists[3], song: songs[6] }
      ]

      playlist_songs_data.each do |data|
        create(:playlist_song, playlist: data[:playlist], song: data[:song])
      end
    end

    it 'returns most popular songs' do
      expect(ordered_songs.length).to eq(7)
    end

    it 'returns an instance of the Song class' do
      expect(ordered_songs.first).to be_an_instance_of(Song)
    end

    it 'returns songs ordered by popularity' do
      expect(descending?(ordered_songs.count.values)).to be(true)
    end
  end
end
