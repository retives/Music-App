# frozen_string_literal: true

class AddUniqueIndexToReactions < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :reactions, %i[user_id playlist_id], unique: true, algorithm: :concurrently
  end
end
