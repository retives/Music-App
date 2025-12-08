# frozen_string_literal: true

module Users
  class MostPopularUsersQuery
    def self.call(relation)
      relation.select('users.*, COUNT(friendships.id)')
        .joins('LEFT JOIN friendships ON users.id = friendships.sender_id OR users.id = friendships.receiver_id')
        .where(friendships: { status: Friendship.statuses[:accepted] })
        .group('users.id')
        .order('COUNT(friendships.id) DESC')
    end
  end
end
