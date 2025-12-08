# frozen_string_literal: true

module Playlists
  class FeaturedPlaylistsQuery
    def self.call(relation)
      relation
        .where(featured: true)
        .order(updated_at: :desc)
    end
  end
end
