# frozen_string_literal: true

class BackfillDataToPasswordDigest < ActiveRecord::Migration[7.0]
  def change
    User.update_all('password_digest = password')
  end
end
