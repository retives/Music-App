# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaylistForm, type: :model do
  subject(:form) do
    described_class.new(
      name: 'Test',
      logo: playlist_logo,
      description: 'Test description'
    )
  end

  let(:current_user) { create(:user) }
  let(:playlist_logo) do
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/images/cover.jpg'),
      'image/jpg'
    )
  end

  describe 'validations' do
    context 'when playlist_type' do
      let(:wrong_form) do
        described_class.new(
          name: 'Test',
          playlist_type: 'other',
          logo: playlist_logo,
          description: 'Test description'
        )
      end

      it { is_expected.to allow_value('private').for(:playlist_type) }
      it { is_expected.to allow_value('public').for(:playlist_type) }
      it { is_expected.to allow_value('shared').for(:playlist_type) }
      it { is_expected.not_to allow_value('other').for(:playlist_type) }

      it 'has playlist type privat when created' do
        expect(form.playlist_type).to be('private')
      end

      it 'does not allow other playlist_type values' do
        expect(wrong_form).not_to be_valid
      end
    end

    context 'when name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to allow_value('Test').for(:name) }
      it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(50) }
    end

    context 'when description' do
      it { is_expected.to allow_value('Test description').for(:description) }
      it { is_expected.to validate_length_of(:description).is_at_least(3).is_at_most(1000) }
    end
  end

  describe '#save' do
    context 'when the form data is valid' do
      let(:params) { { name: 'Test', logo: playlist_logo, description: 'Test description' } }
      let(:form) { described_class.new(current_user, params) }

      it 'returns true' do
        expect(form.save).to be(true)
      end

      it 'creates a new playlist' do
        expect { form.save }.to change(Playlist, :count).by(1)
      end
    end

    context 'when the form data is invalid' do
      let(:invalid_params) { { name: '', logo: playlist_logo, description: 'Test description' } }
      let(:invalid_form) { described_class.new(current_user, invalid_params) }

      it 'returns false' do
        expect(invalid_form.save).to be(false)
      end

      it 'does not create a new playlist' do
        expect { invalid_form.save }.not_to change(Playlist, :count)
      end
    end
  end

  describe '#update' do
    let(:playlist) { create(:playlist, name: 'Test name') }

    context 'when the form data is valid' do
      let(:params) do
        { name: 'Updated name', logo: playlist_logo, description: 'Updated description', id: playlist.id }
      end
      let(:form) { described_class.new(current_user, params) }

      it 'returns true' do
        expect(form.update).to be(true)
      end

      it 'updates the playlist name' do
        form.update
        playlist.reload
        expect(playlist.name).to eq('Updated name')
      end

      it 'updates the playlist description' do
        form.update
        playlist.reload
        expect(playlist.description).to eq('Updated description')
      end
    end

    context 'when the form data is invalid' do
      let(:invalid_params) { { name: '', logo: playlist_logo, description: 'Test description', id: playlist.id } }
      let(:invalid_form) { described_class.new(current_user, invalid_params) }

      it 'returns false' do
        expect(invalid_form.update).to be(false)
      end

      it 'does not update a new playlist' do
        invalid_form.update
        playlist.reload
        expect(playlist.name).to eq('Test name')
      end

      it 'returns validation error' do
        invalid_form.update
        expect(invalid_form.errors[:name]).to include("can't be blank")
      end
    end
  end
end
