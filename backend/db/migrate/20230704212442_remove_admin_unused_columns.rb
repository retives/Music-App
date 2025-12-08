# frozen_string_literal: true

class RemoveAdminUnusedColumns < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      change_table :admin_users, bulk: true do |t|
        t.remove :email, type: :string
        t.remove :password_digest, type: :string
      end
    end
  end
end
