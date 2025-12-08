# frozen_string_literal: true

class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.string :title, index: true
      t.text :cover

      t.timestamps
    end
  end
end
