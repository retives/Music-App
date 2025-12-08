# frozen_string_literal: true

class UpdateUserColumnInPlaylistsToAllowNull < ActiveRecord::Migration[7.0]
  def up
    safety_assured { change_column_null :playlists, :user_id, true }
  end

  def down
    safety_assured { change_column_null :playlists, :user_id, false }
  end
end
