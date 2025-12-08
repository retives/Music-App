# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Option do
  describe 'validations' do
    subject { described_class.new(title: 'Option Title', body: 'Lorem ipsum', handle: 'option_handle') }

    context 'when handle' do
      it { is_expected.to validate_presence_of(:handle) }
      it { is_expected.to allow_value('handle').for(:handle) }
      it { is_expected.not_to allow_value('handle!').for(:handle) }
    end

    context 'when handle is not unique' do
      before { create(:option, handle: 'option_handle') }

      it { is_expected.not_to be_valid }
    end
  end
end
