# frozen_string_literal: true

RSpec.describe PlaylistsFinder do
  describe 'call' do
    let!(:playlists) { create_list(:playlist, 5, playlist_type: 'public') }
    let(:all_playlists) { Playlist.all }

    context 'when playlists without params' do
      let(:params) { {} }
      let(:result) { described_class.call(all_playlists, params)[1] }

      before do
        create(:reaction, playlist_id: playlists[0].id, status: 0)

        create_list(:reaction, 2, playlist_id: playlists[1].id, status: 1)
        create(:reaction, playlist_id: playlists[1].id, status: 0)

        create(:reaction, playlist_id: playlists[2].id, status: 1)
        create(:reaction, playlist_id: playlists[2].id, status: 0)

        create(:reaction, playlist_id: playlists[3].id, status: 1)

        create_list(:reaction, 3, playlist_id: playlists[4].id, status: 1)
        create(:reaction, playlist_id: playlists[4].id, status: 0)
      end

      it 'returns an instance of Playlist' do
        expect(result.first).to be_an_instance_of(Playlist)
      end

      it 'returns all playlists' do
        expect(result.length).to eq(5)
      end

      it 'includes playlists that have zero likes' do
        expect(result).to include(playlists[4])
      end

      it 'returns ordered by number of likes and by date created playlists in DESC direction' do
        expect(result).to eq([playlists[4], playlists[1], playlists[3], playlists[2], playlists[0]])
      end
    end

    context 'when playlists with search param' do
      let(:params) { { search: Playlist.first.name } }

      it 'calls SearchPlaylistsQuery' do
        allow(Playlists::SearchPlaylistsQuery).to receive(:call).with(all_playlists, params[:search])
        Playlists::SearchPlaylistsQuery.call(all_playlists, params[:search])
        expect(Playlists::SearchPlaylistsQuery).to have_received(:call).with(all_playlists, params[:search])
      end
    end

    context 'when playlists with type param: popular' do
      let(:params) { { type: 'popular' } }

      it 'calls PopularPlaylistsQuery' do
        allow(Playlists::PopularPlaylistsQuery).to receive(:call).with(all_playlists)
        Playlists::PopularPlaylistsQuery.call(all_playlists)
        expect(Playlists::PopularPlaylistsQuery).to have_received(:call).with(all_playlists)
      end
    end

    context 'when playlists with type param: last' do
      let(:params) { { type: 'last' } }

      it 'calls SearchPlaylistsQuery' do
        allow(Playlists::LastPlaylistsQuery).to receive(:call).with(all_playlists)
        Playlists::LastPlaylistsQuery.call(all_playlists)
        expect(Playlists::LastPlaylistsQuery).to have_received(:call).with(all_playlists)
      end
    end

    context 'when playlists with type param: featured' do
      let(:params) { { type: 'featured' } }

      it 'calls FeaturedPlaylistsQuery' do
        allow(Playlists::FeaturedPlaylistsQuery).to receive(:call).with(all_playlists)
        Playlists::FeaturedPlaylistsQuery.call(all_playlists)
        expect(Playlists::FeaturedPlaylistsQuery).to have_received(:call).with(all_playlists)
      end
    end

    context 'when playlists with custom sorting' do
      let(:first_playlist) { create(:playlist, name: 'Playlist A', playlist_type: :open) }
      let(:second_playlist) { create(:playlist, name: 'Playlist B', playlist_type: :open, created_at: 1.month.ago) }
      let(:third_playlist) { create(:playlist, name: 'Playlist B', playlist_type: :open, created_at: 1.day.ago) }
      let(:playlists) { [first_playlist, second_playlist, third_playlist] }

      before { playlists }

      context 'when sorting by playlist_name' do
        it 'sorts playlists in asc order' do
          params = { sort_by: 'playlist_name', sort_order: 'asc' }
          result = described_class.call(all_playlists, params)[1]

          expect(result).to eq([first_playlist, third_playlist, second_playlist])
        end

        it 'sorts playlists in desc order' do
          params = { sort_by: 'playlist_name', sort_order: 'desc' }
          result = described_class.call(all_playlists, params)[1]

          expect(result).to eq([third_playlist, second_playlist, first_playlist])
        end
      end

      context 'when sorting by comments_count' do
        before do
          create_list(:comment, 5, playlist: first_playlist)
          create_list(:comment, 3, playlist: second_playlist)
          create_list(:comment, 3, playlist: third_playlist)
        end

        it 'sorts playlists in ascending order' do
          params = { sort_by: 'comments_count', sort_order: 'asc' }
          result = described_class.call(all_playlists, params)[1]

          expect(result).to eq([third_playlist, second_playlist, first_playlist])
        end

        it 'sorts playlists in descending order' do
          params = { sort_by: 'comments_count', sort_order: 'desc' }
          result = described_class.call(all_playlists, params)[1]

          expect(result).to eq([first_playlist, third_playlist, second_playlist])
        end
      end

      context 'when sorting with nil or invalid params' do
        it 'returns the original list of playlists if sort_by is invalid' do
          params = { sort_by: 'invalid', sort_order: 'asc' }
          result = described_class.call(all_playlists, params)[1]

          expect(result).to eq([first_playlist, third_playlist, second_playlist])
        end

        it 'sorts in desc order if sort_order is invalid' do
          params = { sort_by: 'playlist_name', sort_order: 'invalid' }
          result = described_class.call(all_playlists, params)[1]

          expect(result).to eq([third_playlist, second_playlist, first_playlist])
        end

        it 'returns the original list of playlists if sort_by is not present' do
          params = { sort_order: 'asc' }
          result = described_class.call(all_playlists, params)[1]

          expect(result).to eq([first_playlist, third_playlist, second_playlist])
        end
      end
    end
  end
end
