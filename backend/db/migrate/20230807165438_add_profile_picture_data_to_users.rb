# frozen_string_literal: true

class AddProfilePictureDataToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :profile_picture_data, :text
  end
end
