# frozen_string_literal: true

class RemoveCoverFromAlbums < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :albums, :cover, :text }
  end
end
