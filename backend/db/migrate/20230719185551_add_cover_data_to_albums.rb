# frozen_string_literal: true

class AddCoverDataToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :cover_data, :text
  end
end
