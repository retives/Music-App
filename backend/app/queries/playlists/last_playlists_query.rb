# frozen_string_literal: true

module Playlists
  class LastPlaylistsQuery
    def self.call(relation)
      relation.order(created_at: :desc)
    end
  end
end
