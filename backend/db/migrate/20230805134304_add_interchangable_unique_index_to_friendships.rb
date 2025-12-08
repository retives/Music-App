# frozen_string_literal: true

class AddInterchangableUniqueIndexToFriendships < ActiveRecord::Migration[7.0]
  def change
    reversible do |direction|
      direction.up do
        connection.execute('
          create unique index index_friendships_on_interchangable_sender_id_and_receiver_id on friendships(greatest(sender_id,receiver_id), least(sender_id,receiver_id));
          create unique index index_friendships_on_interchangable_receiver_id_and_sender_id on friendships(least(sender_id,receiver_id), greatest(sender_id,receiver_id));
        ')
      end
      direction.down do
        connection.execute('
          drop index index_friendships_on_interchangable_sender_id_and_receiver_id;
          drop index index_friendships_on_interchangable_receiver_id_and_sender_id;
        ')
      end
    end
  end
end
