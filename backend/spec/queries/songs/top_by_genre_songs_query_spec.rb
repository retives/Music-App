# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Songs::TopByGenreSongsQuery, type: :query do
  describe '#call' do
    subject(:result) { described_class.call(relation, top_genres.first.id, 2) }

    before do
      setup_songs_with_genres
      setup_playlist_songs
    end

    let(:relation) { Songs::PopularSongsQuery.call(Song.all) }
    let(:top_genres) { Genres::TopGenresQuery.call(Genre.all, 5) }

    it 'returns genre title within the song data' do
      expect(result[0].genre.title).to eq(top_genres.first.title)
    end

    it 'returns an instance of Song class' do
      result.all do |song|
        expect(song).to be_an_instance_of(Song)
      end
    end

    it 'returns 2 top songs per each genre' do
      expect(result.length).to eq(2)
    end

    it 'returns songs ordered by popularity' do
      ordered_songs = Songs::PopularSongsQuery.call(Song.where(genre_id: top_genres.first.id)).first(2)
      expect(result).to match_array(ordered_songs)
    end

    it 'includes album information for each song' do
      result.each do |song|
        expect(song.album).to be_an_instance_of(Album)
      end
    end
  end
end
