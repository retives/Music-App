# frozen_string_literal: true

class AddLogoDataToPlaylists < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :logo_data, :text
  end
end
