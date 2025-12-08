# frozen_string_literal: true

class Album < ApplicationRecord
  include ImageUploader::Attachment(:cover)

  has_many :songs, dependent: :destroy
end
