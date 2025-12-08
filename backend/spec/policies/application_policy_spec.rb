# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy do
  describe 'default policies for the application' do
    subject(:application_policy) { described_class.new(user, record) }

    context 'with an authenticated user' do
      let(:user) { create(:user) }
      let(:record) { nil }

      it 'disallows everything' do
        expect(application_policy).not_to permit_actions(
          %i[index show create new edit update destroy]
        )
      end
    end

    context 'with a guest' do
      let(:user) { nil }
      let(:record) { nil }

      it 'disallows everything' do
        expect(application_policy).not_to permit_actions(
          %i[index show create new edit update destroy]
        )
      end
    end
  end

  describe 'scope' do
    let(:user) { create(:user) }
    let(:resolved_scope) { described_class::Scope.new(user, nil).resolve }

    it 'returns the correct scope' do
      expect(resolved_scope).to be_nil
    end
  end
end
