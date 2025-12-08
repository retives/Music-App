# frozen_string_literal: true

module Genres
  class TopGenresQuery
    def self.call(relation, limit)
      relation
        .joins(songs: [:playlists])
        .where(playlists: { playlist_type: %w[public private] })
        .group('genres.id')
        .order(Arel.sql('COUNT(DISTINCT playlists.id) DESC, genres.created_at DESC'))
        .limit(limit)
    end
  end
end
