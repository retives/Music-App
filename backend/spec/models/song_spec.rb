# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Song do
  describe 'associations' do
    it { is_expected.to have_many(:playlist_songs).dependent(:destroy) }
    it { is_expected.to have_many(:playlists).through(:playlist_songs) }
    it { is_expected.to have_many(:artist_songs).dependent(:destroy) }
    it { is_expected.to have_many(:artists).through(:artist_songs) }
    it { is_expected.to belong_to(:album) }
    it { is_expected.to belong_to(:genre) }
  end
end
