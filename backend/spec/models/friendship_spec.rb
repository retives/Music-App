# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship do
  describe 'associations' do
    it { is_expected.to belong_to(:sender).class_name('User') }
    it { is_expected.to belong_to(:receiver).class_name('User') }
  end
end
