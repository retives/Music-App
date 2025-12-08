# frozen_string_literal: true

module Songs
  class PopularSongsQuery
    def self.call(relation)
      relation
        .joins(playlist_songs: :playlist)
        .where(playlists: { playlist_type: %w[public private] })
        .group('songs.id')
        .order('COUNT(playlist_songs.id) DESC')
    end
  end
end
