# frozen_string_literal: true

class CreateDeletedUserData < ActiveRecord::Migration[7.0]
  def change
    create_table :deleted_user_data do |t|
      t.string :user_email
      t.text :friends_ids

      t.timestamps
    end
  end
end
