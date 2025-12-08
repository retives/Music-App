# frozen_string_literal: true

module Playlists
  class SearchPlaylistsQuery
    def self.call(relation, query)
      new(relation, query).call
    end

    def initialize(relation, query)
      @relation = relation
      @query = query&.to_s&.strip&.downcase
    end

    def call
      @relation.includes(:user, songs: :artists).where(conditions).references(:user, songs: :artists)
    end

    private

    def conditions
      fields = %w[playlists.name playlists.description users.nickname songs.title artists.name]
      fields.map { |field| "lower(#{field}) LIKE '%#{@query}%'" }.join(' OR ')
    end
  end
end
