# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlists::PopularPlaylistsQuery, type: :query do
  subject(:most_popular_playlists) { described_class.call(Playlist.all) }

  describe '#call' do
    let!(:songs) { create_list(:song, 5) }

    let!(:playlists) do
      [
        create(:playlist, created_at: 2.months.ago),
        create(:playlist, created_at: 3.months.ago),
        create(:playlist, created_at: 4.months.ago),
        create(:playlist, created_at: 5.months.ago),
        create(:playlist, created_at: 1.hour.ago)
      ]
    end

    let!(:empty_playlist) { create(:playlist, created_at: 6.months.ago) }

    before do
      playlists.each do |playlist|
        songs.each do |song|
          create(:playlist_song, playlist:, song:)
        end
      end

      create_list(:reaction, 8, playlist_id: playlists[0].id, status: 1)
      create_list(:reaction, 7, playlist_id: playlists[1].id, status: 1)
      create_list(:reaction, 6, playlist_id: playlists[2].id, status: 1)
      create_list(:reaction, 5, playlist_id: playlists[3].id, status: 1)
      create_list(:reaction, 12, playlist_id: playlists[4].id, status: 1)
      create_list(:reaction, 10, playlist_id: empty_playlist.id, status: 1)
    end

    it 'returns an instance of the Playlist class' do
      expect(most_popular_playlists.first).to be_an_instance_of(Playlist)
    end

    it 'returns playlists that created months ago or more' do
      condition = described_class::MIN_MONTHS_OLD

      expect(most_popular_playlists.all? { |playlist| playlist.created_at >= condition }).to be(true)
    end

    it 'returns playlists with required amount of songs' do
      condition = described_class::REQUIRED_AMOUNT_OF_SONGS
      expect(most_popular_playlists.all? { |playlist| playlist.songs.count >= condition }).to be(true)
    end

    it 'returns most popular playlists in correct order' do
      expect(most_popular_playlists).to eq([playlists[0], playlists[1], playlists[2], playlists[3]])
    end

    it 'does not include recently created playlist' do
      expect(most_popular_playlists).not_to include(playlists[4])
    end

    it 'does not include playlist without songs' do
      expect(most_popular_playlists).not_to include(empty_playlist)
    end
  end
end
