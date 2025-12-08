# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre do
  describe 'associations' do
    it { is_expected.to have_many(:songs).dependent(:destroy) }
  end
end
