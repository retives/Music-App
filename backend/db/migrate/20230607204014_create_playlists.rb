# frozen_string_literal: true

class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_enum :playlist_type, %w[private shared public]

    create_table :playlists do |t|
      t.enum :playlist_type, enum_type: :playlist_type, default: 'private', null: false
      t.string :name
      t.text :logo
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
