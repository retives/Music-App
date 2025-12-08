# frozen_string_literal: true

class CreateGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :genres do |t|
      t.string :title

      t.timestamps
    end

    add_index :genres, ['title'], unique: true
  end
end
