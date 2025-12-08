# frozen_string_literal: true

RSpec.describe GenresFinder do
  describe 'call' do
    subject(:result) { described_class.call(params) }

    let(:query) { class_spy(Genres::TopGenresQuery) }

    before do
      setup_songs_with_genres
      setup_playlist_songs
    end

    context 'when genres without params' do
      let(:params) { {} }

      it 'returns all genres' do
        expect(result).to eq(Genre.all)
      end
    end

    context 'when genres with params top: true' do
      let(:limit) { nil }
      let(:params) { { top: true } }

      it 'calls TopGenresQuery' do
        allow(query).to receive(:call).with(Genre.all, limit)
        query.call(Genre.all, limit)
        expect(query).to have_received(:call).with(Genre.all, limit)
      end

      it 'returns all genres' do
        expect(result.count).to eq(Genre.count)
      end
    end

    context 'when genres with params top: false' do
      let(:limit) { nil }
      let(:params) { { top: false } }

      it 'does not call TopGenresQuery' do
        expect(query).not_to have_received(:call)
      end

      it 'returns all genres' do
        expect(result).to eq(Genre.all)
      end
    end

    context 'when genres with params top and limit' do
      let(:limit) { 5 }
      let(:params) { { top: true, limit: } }

      it 'calls TopGenresQuery' do
        allow(query).to receive(:call).with(Genre.all, limit)
        query.call(Genre.all, limit)
        expect(query).to have_received(:call).with(Genre.all, limit)
      end

      it 'returns only 5 top genres' do
        expect(result.count).to eq(5)
      end
    end
  end
end
