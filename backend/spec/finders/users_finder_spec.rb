# frozen_string_literal: true

RSpec.describe UsersFinder do
  describe 'call' do
    subject(:result) { described_class.call(params)[1] }

    let(:users) { create_list(:user, 5) }

    before { users }

    context 'when user_type is popular' do
      let(:params) { { user_type: 'popular' } }

      it 'calls MostPopularUsersQuery' do
        allow(Users::MostPopularUsersQuery).to receive(:call).with(users)
        Users::MostPopularUsersQuery.call(users)
        expect(Users::MostPopularUsersQuery).to have_received(:call).with(users)
      end
    end

    context 'when user_type is contributor' do
      let(:params) { { user_type: 'contributor' } }

      it 'calls TopContributorsQuery' do
        allow(Users::TopContributorsQuery).to receive(:call).with(users)
        Users::TopContributorsQuery.call(users)
        expect(Users::TopContributorsQuery).to have_received(:call).with(users)
      end
    end
  end
end
