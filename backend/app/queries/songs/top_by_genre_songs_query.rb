# frozen_string_literal: true

module Songs
  class TopByGenreSongsQuery
    def self.call(relation, genre_id, limit)
      relation.where(genre_id:).limit(limit)
    end
  end
end
