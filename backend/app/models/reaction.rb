# frozen_string_literal: true

class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :playlist

  validates :status, inclusion: { in: [0, 1] }
end
