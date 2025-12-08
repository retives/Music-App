# frozen_string_literal: true

class AddUserToPlaylistSongs < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :playlist_songs, :user_id, :integer
    add_index :playlist_songs, :user_id, algorithm: :concurrently
  end
end
