# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserForm, type: :model do
  subject(:form) do
    described_class.new(
      email: 'test@gmail.com',
      nickname: 'Test_Test',
      password: 'P!1000assword',
      password_confirmation: 'P!1000assword'
    )
  end

  describe 'validations' do
    context 'when email' do
      it { is_expected.to allow_value('test@gmail.com').for(:email) }
      it { is_expected.to allow_value('test_user@example.com').for(:email) }
      it { is_expected.not_to allow_values('test@test', 'invalid_email', 'test@.com').for(:email) }
      it { is_expected.not_to allow_values('test user@example.com', 'test+user@example.com').for(:email) }
      it { is_expected.not_to allow_values('testuser@exa mple.com', 'testuser@exa+mple.com').for(:email) }
      it { is_expected.not_to allow_values('test`user@example.com', 'test~user@example.com').for(:email) }
    end

    context 'when nickname' do
      it { is_expected.to allow_value('Test_Test', 'Test#Test', 'TestTest', 'Test', 'test').for(:nickname) }
      it { is_expected.not_to allow_value('InvalidNickname$', 'Invalid nickname').for(:nickname) }
      it { is_expected.to validate_length_of(:nickname).is_at_least(3).is_at_most(50) }
    end

    context 'when password' do
      it { is_expected.to allow_value('P!1000assword').for(:password) }
      it { is_expected.to allow_value('P_@#$%^&*()_-+=}{][/1000assword').for(:password) }
      it { is_expected.to validate_length_of(:password).is_at_most(128) }
      it { is_expected.not_to allow_value('weak password').for(:password) }
      it { is_expected.not_to allow_value('P!1000assword"').for(:password) }
      it { is_expected.not_to allow_value('P!1000as"sword\'').for(:password) }
      it { is_expected.not_to allow_value('P!1000a\'\'ssword\0').for(:password) }
      it { is_expected.not_to allow_value('P!100\\0assword\\').for(:password) }
    end
  end

  describe '#save' do
    context 'when the form data is valid' do
      it 'returns true' do
        expect(form.save).to be(true)
      end

      it 'creates a new user' do
        form.save
        expect(User.count).to eq(1)
      end
    end

    context 'when the form data is invalid' do
      let(:invalid_form) do
        described_class.new(
          email: 'invalid_email',
          nickname: 'Test Test',
          password: 'weak',
          password_confirmation: 'secret!'
        )
      end

      it 'returns false' do
        expect(invalid_form.save).to be(false)
      end

      it 'does not create a new user' do
        expect(User.count).to eq(0)
      end
    end
  end

  describe 'email uniqueness validation' do
    context 'when email is already taken' do
      before { create(:user, email: 'test@gmail.com') }

      it 'is not valid' do
        expect(form.save).to be(false)
      end

      it 'is not valid and have error' do
        form.save
        expect(form.errors[:email]).to include('has already been taken')
      end
    end

    context 'when email is not taken' do
      before { create(:user, email: 'another_user@gmail.com') }

      it 'is valid' do
        expect(form.save).to be(true)
      end

      it 'is not have error' do
        form.save
        expect(form.errors[:nickname]).to be_empty
      end
    end
  end

  describe 'nickname uniqueness validation' do
    context 'when nickname is already taken' do
      before { create(:user, nickname: 'Test_Test') }

      it 'is not valid' do
        expect(form.save).to be(false)
      end

      it 'is not valid and have error' do
        form.save
        expect(form.errors[:nickname]).to include('has already been taken')
      end
    end

    context 'when nickname is not taken' do
      before { create(:user, nickname: 'Another_user') }

      it 'is valid' do
        expect(form.save).to be(true)
      end

      it 'have no error' do
        form.save
        expect(form.errors[:nickname]).to be_empty
      end
    end
  end

  describe 'password confirmation' do
    context 'when password is confirmed' do
      it 'new user created' do
        expect(form.save).to be(true)
      end
    end

    context 'when password confirmation failed' do
      let(:invalid_form) do
        described_class.new(
          email: 'test.user.01@mail.com',
          nickname: 'Test_User',
          password: 'secreT!123',
          password_confirmation: 'secreT!1234'
        )
      end

      it 'user not saved, error returned' do
        expect(invalid_form.save).to be(false)
      end
    end
  end
end
