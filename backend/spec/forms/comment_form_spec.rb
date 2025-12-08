# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentForm, type: :model do
  let(:user) { create(:user) }
  let(:playlist) { create(:playlist, playlist_type: 'public', user:) }
  let(:content) { 'This is a test comment.' }
  let(:form) { described_class.new(user, playlist, content) }

  describe 'validations' do
    context 'when user exceeds the maximum comments per minute' do
      before do
        create_list(
          :comment,
          CommentForm::MAX_COMMENTS_COUNT,
          user:,
          created_at: Time.zone.now - CommentForm::TIME_THRESHOLD + 10.seconds
        )
      end

      it 'does not allow saving comment' do
        max_comment_count = CommentForm::MAX_COMMENTS_COUNT
        time_threshold = CommentForm::TIME_THRESHOLD
        expect(form).not_to be_valid
        expect(form.errors[:base]).to eq([I18n.t('errors.too_many_comments', max_comment_count:, time_threshold:)])
      end
    end

    context 'when the comment content is too short' do
      let(:content) { 'a' * (described_class::MIN_COMMENT_LENGTH - 1) }

      it 'does not allow saving comment' do
        expect(form).not_to be_valid
        expect(
          form.errors[:content]
        ).to include("is too short (minimum is #{CommentForm::MIN_COMMENT_LENGTH} characters)")
      end
    end

    context 'when the comment content is too long' do
      let(:content) { 'a' * (described_class::MAX_COMMENT_LENGTH + 1) }

      it 'does not allow saving comment' do
        expect(form).not_to be_valid
        expect(
          form.errors[:content]
        ).to include("is too long (maximum is #{CommentForm::MAX_COMMENT_LENGTH} characters)")
      end
    end
  end
end
