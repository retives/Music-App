# frozen_string_literal: true

class CreateArtistSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :artist_songs do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true

      t.timestamps
    end

    add_index :artist_songs, %i[artist_id song_id]
  end
end
