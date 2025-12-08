# frozen_string_literal: true

RSpec.describe PlaylistMailer do
  describe 'playlist_milestone_email' do
    subject(:mail) { described_class.with(user:).playlist_milestone_email(milestone) }

    let(:user) { create(:user) }
    let(:milestone) { 10 }

    it 'renders the subject' do
      expect(mail.subject).to eql('Congratulations on creating 10 playlists!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['from@example.com'])
    end

    it 'assigns @user.nickname' do
      expect(mail.body.encoded).to match(user.nickname)
    end

    it 'assigns @milestone' do
      expect(mail.body.encoded).to match('10')
    end
  end
end
