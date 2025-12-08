# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserAccountForm, type: :model do
  subject(:form) do
    described_class.new(
      nickname: 'Test',
      email: 'test.example@example.com',
      profile_picture:
    )
  end

  let(:current_user) { create(:user) }
  let(:profile_picture) do
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/images/user_default_image.png'),
      'image/png'
    )
  end

  describe 'validations' do
    context 'when nickname' do
      it { is_expected.to allow_value('Test').for(:nickname) }
      it { is_expected.not_to allow_value('Invalid nickname').for(:nickname) }
      it { is_expected.to validate_length_of(:nickname).is_at_least(3).is_at_most(50) }
    end

    context 'when email' do
      it { is_expected.to allow_value('test.example@example.com').for(:email) }
      it { is_expected.not_to allow_values('test user@example.com').for(:email) }
    end
  end

  describe 'email uniqueness validation' do
    context 'when email is already taken' do
      let(:params) { { email: 'test.example@example.com' } }
      let(:form) { described_class.new(current_user, params) }

      before { create(:user, email: 'test.example@example.com') }

      it 'is not valid' do
        expect(form.update).to be(false)
      end

      it 'is not valid and have error' do
        form.update
        expect(form.errors[:email]).to include('has already been taken')
      end
    end

    context 'when email is not taken' do
      let(:params) { { email: 'other.example@example.com' } }
      let(:form) { described_class.new(current_user, params) }

      it 'is valid' do
        expect(form.update).to be(true)
      end

      it 'is not have error' do
        form.update
        expect(form.errors[:email]).to be_empty
      end

      it 'updates email' do
        form.update
        current_user.reload
        expect(current_user.email).to eq('other.example@example.com')
      end
    end

    context 'when email is equal current_user' do
      let(:params) { { email: current_user.email } }
      let(:form) { described_class.new(current_user, params) }

      it 'is valid' do
        expect(form.update).to be(true)
      end

      it 'have no error' do
        form.update
        expect(form.errors[:email]).to be_empty
      end
    end
  end

  describe 'nickname uniqueness validation' do
    context 'when nickname is already taken' do
      before { create(:user, nickname: 'Test') }

      let(:params) { { nickname: 'Test' } }
      let(:form) { described_class.new(current_user, params) }

      it 'is not valid' do
        expect(form.update).to be(false)
      end

      it 'is not valid and have error' do
        form.update
        expect(form.errors[:nickname]).to include('has already been taken')
      end
    end

    context 'when nickname is not taken' do
      let(:params) { { nickname: 'Other_Test' } }
      let(:form) { described_class.new(current_user, params) }

      it 'is valid' do
        expect(form.update).to be(true)
      end

      it 'have no error' do
        form.update
        expect(form.errors[:nickname]).to be_empty
      end

      it 'updates nickname' do
        form.update
        current_user.reload
        expect(current_user.nickname).to eq('Other_Test')
      end
    end

    context 'when nickname is equal current_user' do
      let(:params) { { nickname: current_user.nickname } }
      let(:form) { described_class.new(current_user, params) }

      it 'is valid' do
        expect(form.update).to be(true)
      end

      it 'have no error' do
        form.update
        expect(form.errors[:nickname]).to be_empty
      end
    end
  end

  describe 'profile picture validation' do
    context 'when profile picture is not valid' do
      let(:profile_picture) do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/images/invalid_user_image.xcf'),
          'image/png'
        )
      end
      let(:params) { { profile_picture: } }
      let(:form) { described_class.new(current_user, params) }

      it 'is not valid' do
        expect(form.update).to be(false)
      end

      it 'adds errors to the profile_picture field' do
        form.update
        expect(form.errors[:profile_picture]).to include('extension must be one of: jpg, jpeg, png, svg')
      end
    end

    context 'when profile picture is valid' do
      let(:params) { { profile_picture: } }
      let(:form) { described_class.new(current_user, params) }

      it 'is valid' do
        expect(form.update).to be(true)
      end
    end

    context 'when changing profile picture image => image' do
      let(:next_profile_picture) do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/images/cover.jpg'),
          'image/jpg'
        )
      end
      let(:params) { { profile_picture: next_profile_picture } }
      let(:form) { described_class.new(current_user, params) }

      before do
        current_user.update(profile_picture:)
      end

      it 'deletes the previous picture' do
        previous_picture = current_user.profile_picture
        form.update
        expect(previous_picture.exists?).to be false
      end

      it 'keeps the next picture' do
        form.update
        next_picture = current_user.profile_picture
        expect(next_picture.exists?).to be true
      end
    end

    context 'when changing profile picture image => nil' do
      let(:params) { { profile_picture: nil } }
      let(:form) { described_class.new(current_user, params) }

      before do
        current_user.update(profile_picture:)
      end

      it 'deletes the previous picture' do
        previous_picture = current_user.profile_picture
        form.update
        expect(previous_picture.exists?).to be false
      end

      it 'exists the next picture as nil' do
        form.update
        next_picture = current_user.profile_picture
        expect(next_picture).to be_nil
      end
    end

    context 'when changing profile picture nil => imag' do
      let(:next_profile_picture) do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/images/cover.jpg'),
          'image/jpg'
        )
      end
      let(:params) { { profile_picture: next_profile_picture } }
      let(:form) { described_class.new(current_user, params) }

      before do
        current_user.update(profile_picture: nil)
      end

      it 'exists the next picture' do
        form.update
        next_picture = current_user.profile_picture
        expect(next_picture.exists?).to be true
      end

      it 'exists the previous picture as nil' do
        previous_picture = current_user.profile_picture
        form.update
        expect(previous_picture).to be_nil
      end
    end
  end
end
