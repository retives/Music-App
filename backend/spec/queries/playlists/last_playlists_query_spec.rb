# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlists::LastPlaylistsQuery, type: :query do
  describe '#call' do
    subject(:last_playlists) { described_class.call(Playlist.all) }

    let!(:playlists) do
      [
        create(:playlist, created_at: 60.minutes.ago),
        create(:playlist, created_at: 1.minute.ago),
        create(:playlist, created_at: 3.minutes.ago),
        create(:playlist, playlist_type: 'public', created_at: 4.minutes.ago),
        create(:playlist, playlist_type: 'public', created_at: 5.minutes.ago),
        create(:playlist, playlist_type: 'public', created_at: 6.minutes.ago)
      ]
    end

    it 'returns an instance of the Playlist class' do
      expect(last_playlists.first).to be_an_instance_of(Playlist)
    end

    it 'returns all recently created playlists' do
      expect(last_playlists).to match_array(playlists)
    end

    it 'returns playlists in correct order' do
      expect(last_playlists).to eq([playlists[1], playlists[2], playlists[3], playlists[4], playlists[5], playlists[0]])
    end
  end
end
