# frozen_string_literal: true

class Option < ApplicationRecord
  HANDLE_FORMAT = /\A[a-z_]+\z/i

  validates :handle, presence: true, uniqueness: true
  validates :handle, format: { with: HANDLE_FORMAT }

  has_rich_text :body
end
