# frozen_string_literal: true

module Users
  class TopContributorsQuery
    def self.call(relation)
      relation.joins('LEFT JOIN playlists ON users.id = playlists.user_id')
        .select('users.*, COUNT(playlists.id)')
        .group('users.id')
        .order('COUNT(playlists.id) DESC')
    end
  end
end
