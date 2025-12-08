# frozen_string_literal: true

class RemovePasswordFromUsers < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :users, :password, :string }
  end
end
