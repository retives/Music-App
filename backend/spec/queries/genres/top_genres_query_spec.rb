# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genres::TopGenresQuery, type: :query do
  describe '#call' do
    let(:genres) { create_list(:genre, 6) }

    let(:playlists) do
      create_list(:playlist, 3, playlist_type: 'public')
    end

    before do
      [
        create(:playlist_song, playlist: playlists[0], song: create(:song, genre: genres[5])),

        create(:playlist_song, playlist: playlists[1], song: create(:song, genre: genres[5])),
        create(:playlist_song, playlist: playlists[1], song: create(:song, genre: genres[1])),

        create(:playlist_song, playlist: playlists[2], song: create(:song, genre: genres[0])),
        create(:playlist_song, playlist: playlists[2], song: create(:song, genre: genres[1])),
        create(:playlist_song, playlist: playlists[2], song: create(:song, genre: genres[2])),
        create(:playlist_song, playlist: playlists[2], song: create(:song, genre: genres[3])),
        create(:playlist_song, playlist: playlists[2], song: create(:song, genre: genres[4])),
        create(:playlist_song, playlist: playlists[2], song: create(:song, genre: genres[5]))
      ]
    end

    it 'returns top 5 genres' do
      ordered_genres = described_class.call(Genre.all, 5)
      expect(ordered_genres.length).to eq(5)
    end

    it 'returns an instance of Genre' do
      ordered_genres = described_class.call(Genre.all, 5)
      expect(ordered_genres.first).to be_an_instance_of(Genre)
    end

    it 'returns genres ordered by popularity' do
      ordered_genres = described_class.call(Genre.all, 5)

      expect(ordered_genres).to eq([genres[5], genres[1], genres[4], genres[3], genres[2]])
    end
  end
end
