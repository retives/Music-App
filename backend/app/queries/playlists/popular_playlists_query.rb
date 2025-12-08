# frozen_string_literal: true

module Playlists
  class PopularPlaylistsQuery
    REQUIRED_AMOUNT_OF_SONGS = 5
    MIN_MONTHS_OLD = 1
    LIKED_STATUS = 1

    def self.call(relation)
      relation
        .joins(:songs)
        .joins("LEFT JOIN reactions ON playlists.id = reactions.playlist_id AND reactions.status = #{LIKED_STATUS}")
        .where('playlists.created_at <= ?', MIN_MONTHS_OLD.months.ago)
        .group('playlists.id')
        .having("COUNT(songs.id) >= #{REQUIRED_AMOUNT_OF_SONGS}")
        .order('COUNT(reactions.id) DESC, playlists.created_at DESC')
    end
  end
end
