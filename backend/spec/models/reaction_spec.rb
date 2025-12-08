# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reaction do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:playlist) }
  end

  describe 'validate' do
    it { is_expected.to validate_inclusion_of(:status).in_array(%w[0 1]) }
  end
end
