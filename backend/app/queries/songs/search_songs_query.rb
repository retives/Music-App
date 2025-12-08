# frozen_string_literal: true

module Songs
  class SearchSongsQuery
    def self.call(relation, search_term)
      relation.where('title ILIKE ?', "%#{search_term}%")
    end
  end
end
