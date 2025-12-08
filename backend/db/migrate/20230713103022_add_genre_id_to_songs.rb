# frozen_string_literal: true

class AddGenreIdToSongs < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :songs, :genre_id, :bigint
    add_index :songs, :genre_id, algorithm: :concurrently
  end
end
