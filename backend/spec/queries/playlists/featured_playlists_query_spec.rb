# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlists::FeaturedPlaylistsQuery, type: :query do
  describe '#call' do
    subject(:featured_playlists) { described_class.call(Playlist.all) }

    let!(:lists) do
      playlists = []

      8.times.each_with_index do |_, index|
        counter = index + 2
        Timecop.freeze(Time.current - counter.hours) do
          playlist = create(:playlist, playlist_type: 'public', featured: true)
          playlists << playlist
        end
      end

      playlists
    end

    let!(:not_featured_playlists) { create_list(:playlist, 2, playlist_type: 'public') }

    it 'returns an instance of the Playlist class' do
      expect(featured_playlists.first).to be_an_instance_of(Playlist)
    end

    it 'returns only featured playlists' do
      expect(featured_playlists.map(&:featured).all?(true)).to be(true)
    end

    it 'returns only recently marked as featured playlists' do
      expect(featured_playlists).to match_array(lists)
    end

    it 'returns playlists in correct order' do
      expect(featured_playlists).to contain_exactly(lists[0], lists[1], lists[2], lists[3], lists[4], lists[5],
                                                    lists[6], lists[7])
    end

    it 'does not include not featured playlists' do
      expect(featured_playlists).not_to include(not_featured_playlists[0], not_featured_playlists[1])
    end
  end
end
