# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::MostPopularUsersQuery, type: :query do
  describe 'call' do
    let!(:users) { create_list(:user, 5) }

    before do
      create_list(:friendship, 5, receiver_id: users[0].id, status: 'accepted')
      create_list(:friendship, 4, receiver_id: users[1].id, status: 'accepted')
      create_list(:friendship, 3, receiver_id: users[2].id, status: 'accepted')
      create_list(:friendship, 2, receiver_id: users[3].id, status: 'accepted')
      create_list(:friendship, 1, receiver_id: users[4].id, status: 'accepted')
    end

    it 'returns exaclty 5 most popular users' do
      expect(described_class.call(User.all).length).to eq(20)
    end

    it 'returns most popular users in correct order' do
      expect(described_class.call(User.all).first(5)).to match([users[0], users[1], users[2], users[3], users[4]])
    end
  end
end
