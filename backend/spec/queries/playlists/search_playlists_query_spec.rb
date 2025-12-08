# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlists::SearchPlaylistsQuery, type: :query do
  describe '#call' do
    let(:users) do
      [
        create(:user, nickname: 'Sam'),
        create(:user, nickname: 'Jack')
      ]
    end

    let(:playlists) do
      [
        create(:playlist, playlist_type: 'public', name: 'Summer', description: 'Heat', user_id: users[0].id),
        create(:playlist, playlist_type: 'public', name: 'Winter', description: 'Cold', user_id: users[1].id),
        create(:playlist, playlist_type: 'public', name: 'Autumn', description: 'heat', user_id: users[1].id)
      ]
    end

    let(:songs) do
      [
        create(:song, title: 'American way'),
        create(:song, title: 'Long road'),
        create(:song, title: 'Strong apple')
      ]
    end

    let(:artists) do
      [
        create(:artist, name: 'Nikki'),
        create(:artist, name: 'Mango')
      ]
    end

    let(:all_playlists) { Playlist.all }

    before do
      [
        create(:playlist_song, playlist: playlists[0], song: songs[0]),
        create(:playlist_song, playlist: playlists[0], song: songs[1]),

        create(:playlist_song, playlist: playlists[1], song: songs[1]),
        create(:playlist_song, playlist: playlists[1], song: songs[2]),

        create(:playlist_song, playlist: playlists[2], song: songs[0]),
        create(:playlist_song, playlist: playlists[2], song: songs[2]),

        create(:artist_song, song: songs[0], artist: artists[0]),
        create(:artist_song, song: songs[1], artist: artists[1]),
        create(:artist_song, song: songs[2], artist: artists[1])
      ]
    end

    context 'when search playlist by name' do
      it 'returns correct amount of playlists with specified name' do
        search = playlists[1].name
        expect(described_class.call(all_playlists, search).size).to eq(1)
      end

      it 'includes playlist with searhed name' do
        search = playlists[1].name
        expect(described_class.call(all_playlists, search)).to include(playlists[1])
      end

      it 'does not includes other playlists' do
        search = playlists[1].name
        expect(described_class.call(all_playlists, search)).not_to include(playlists[0])
      end

      it 'finds playlist if input with upcase' do
        search = 'SUmmER'
        expect(described_class.call(all_playlists, search)).to include(playlists[0])
      end
    end

    context 'when search playlists by description' do
      it 'returns all playlists that contain searched word' do
        search = 'heat'
        expect(described_class.call(all_playlists, search).size).to eq(2)
      end
    end

    context 'when search playlist by owner nickname' do
      it 'returns correct amount of playlists' do
        search = users[0].nickname
        expect(described_class.call(all_playlists, search).size).to eq(1)
      end

      it 'includes playlist with searhed user name' do
        search = users[0].nickname
        expect(described_class.call(all_playlists, search)).to include(playlists[0])
      end

      it 'does not include other users playlists' do
        search = users[0].nickname
        expect(described_class.call(all_playlists, search)).not_to include(playlists[1])
      end
    end

    context 'when search playlist by songs title' do
      it 'returns correct amount of playlists with searhed song' do
        search = songs[0].title
        expect(described_class.call(all_playlists, search).size).to eq(2)
      end

      it 'include playlists with searhed song' do
        search = songs[0].title
        expect(described_class.call(all_playlists, search)).to include(playlists[0], playlists[2])
      end

      it 'does not include playlists without specified song' do
        search = songs[0].title
        expect(described_class.call(all_playlists, search)).not_to include(playlists[1])
      end
    end

    context 'when search playlist by artist name' do
      it 'returns correct amount of playlists with songs of spesified artist' do
        search = artists[0].name
        expect(described_class.call(all_playlists, search).size).to eq(2)
      end

      it 'returns all playlists with songs of spesified artist' do
        search = artists[0].name
        expect(described_class.call(all_playlists, search)).to include(playlists[0], playlists[2])
      end

      it 'does not return playlists which not contain songs of spesified artist' do
        search = artists[0].name
        expect(described_class.call(all_playlists, search)).not_to include(playlists[1])
      end
    end
  end
end
