# frozen_string_literal: true

class AddFeaturedToPlaylists < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      change_table :playlists, bulk: true do |t|
        t.boolean :featured, null: false, default: false
      end
    end
  end
end
