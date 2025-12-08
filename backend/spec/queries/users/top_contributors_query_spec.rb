# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::TopContributorsQuery, type: :query do
  describe 'call' do
    let!(:users) { create_list(:user, 5) }

    before do
      create_list(:playlist, 5, user_id: users[0].id)
      create_list(:playlist, 4, user_id: users[1].id)
      create_list(:playlist, 3, user_id: users[2].id)
      create_list(:playlist, 2, user_id: users[3].id)
      create_list(:playlist, 1, user_id: users[4].id)
    end

    it 'returns exaclty 5 top contributors' do
      expect(described_class.call(User.all).length).to eq(5)
    end

    it 'returns top contributors in correct order' do
      expect(described_class.call(User.all)).to match([users[0], users[1], users[2], users[3], users[4]])
    end
  end
end
