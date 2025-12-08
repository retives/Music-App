# frozen_string_literal: true

class AddPasswordDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_digest, :string, column_options: { default: '', null: false }
  end
end
