# frozen_string_literal: true

RSpec.describe SongsFinder do
  describe 'call' do
    subject(:result) { described_class.call(params)[1] }

    let(:songs) { create_list(:song, 5) }

    before { songs }

    context 'when songs without params' do
      let(:params) { {} }

      it 'returns all songs' do
        expect(result.count).to eq(Song.count)
      end
    end

    context 'when param search is provided' do
      let(:params) { { search: songs.first.title } }

      it 'calls SearchSongsQuery' do
        allow(Songs::SearchSongsQuery).to receive(:call).with(songs, params[:search])
        Songs::SearchSongsQuery.call(songs, params[:search])
        expect(Songs::SearchSongsQuery).to have_received(:call).with(songs, params[:search])
      end
    end

    context 'when param popular is provided' do
      let(:params) { { popular: true } }

      it 'calls PopularSongsQuery' do
        allow(Songs::PopularSongsQuery).to receive(:call).with(songs)
        Songs::PopularSongsQuery.call(songs)
        expect(Songs::PopularSongsQuery).to have_received(:call).with(songs)
      end
    end

    context 'when sorting params are provided' do
      let(:params) { { sort_by: 'created_at', sort_order: 'asc' } }

      it 'returns sorted songs' do
        ordered_songs = Song.order('created_at asc')
        expect(result.to_a).to eq(ordered_songs.to_a)
      end
    end
  end
end
