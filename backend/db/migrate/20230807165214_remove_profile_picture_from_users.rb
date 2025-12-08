# frozen_string_literal: true

class RemoveProfilePictureFromUsers < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :users, :profile_picture, :text }
  end
end
