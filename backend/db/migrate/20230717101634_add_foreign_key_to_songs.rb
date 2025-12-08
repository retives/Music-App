# frozen_string_literal: true

class AddForeignKeyToSongs < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_foreign_key :songs, :genres, validate: false
  end
end
