# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipForm, type: :model do
  let(:user) { create(:user, email: 'test@example.com') }
  let(:receiver) { create(:user, email: 'receiver@example.com') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      form = described_class.new(user, receiver.email)
      expect(form).to be_valid
    end

    it 'is invalid without an email' do
      form = described_class.new(user, nil)
      expect(form).to be_invalid
    end

    it 'is invalid without a user' do
      form = described_class.new(nil, user.email)
      expect(form).to be_invalid
    end

    it 'is invalid when user does not exist' do
      form = described_class.new(user, 'random@email.com')
      expect(form).to be_invalid
      expect(form.errors[:email]).to include(I18n.t('errors.user_not_exist'))
    end

    it 'is invalid when sending friend request to self' do
      form = described_class.new(user, user.email)
      expect(form).to be_invalid
      expect(form.errors[:email]).to include(I18n.t('errors.your_email'))
    end

    it 'is invalid when a friend request already created' do
      create(:friendship, status: 'pending', sender: user, receiver:)
      form = described_class.new(user, receiver.email)
      expect(form).to be_invalid
      expect(form.errors[:email]).to include(I18n.t('errors.pending_friendship_exists'))
    end

    it 'is invalid when a friendship already exists' do
      create(:friendship, status: 'accepted', sender: user, receiver:)
      form = described_class.new(user, receiver.email)
      expect(form).to be_invalid
      expect(form.errors[:email]).to include(I18n.t('errors.accepted_friendship_exists'))
    end
  end

  describe '#save' do
    context 'with valid attributes' do
      it 'creates a friendship' do
        form = described_class.new(user, receiver.email)
        expect { form.save }.to change(Friendship, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a friendship' do
        form = described_class.new(user, nil)
        expect { form.save }.not_to change(Friendship, :count)
      end
    end
  end
end
