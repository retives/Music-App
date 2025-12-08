# frozen_string_literal: true

class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options do |t|
      t.string :title
      t.string :handle, null: false, index: { unique: true }
      t.text :body

      t.timestamps
    end
  end
end
