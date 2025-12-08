# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Songs::SearchSongsQuery, type: :query do
  let(:songs) do
    create_list(:song, 3)
  end

  let(:relation) { Song.includes(:artists, :album) }

  describe '#call' do
    context 'when search query is present' do
      let(:params) { { search: songs.first.title } }

      it 'returns scoped results with the search query' do
        results = described_class.call(relation, params[:search])

        expect(results).to include(songs.first)
      end
    end

    context 'when search query is blank' do
      let(:params) { { search: '' } }

      it 'returns the initial scope without any filters' do
        results = described_class.call(relation, params[:search])

        expect(results).to eq(songs)
      end
    end
  end
end
