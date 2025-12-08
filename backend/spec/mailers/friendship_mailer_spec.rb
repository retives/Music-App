# frozen_string_literal: true

RSpec.describe 'FriendshipMailer' do
  describe 'invitation_email' do
    subject(:mail) { FriendshipMailer.with(user:).invitation_email(friend_email) }

    let(:user) { create(:user) }
    let(:friend_email) { 'tetiana@gmail.com' }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('mailer.invitation_email_subject', app_name: ApplicationMailer::APP_NAME))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([friend_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['from@example.com'])
    end

    it 'assigns @user.nickname' do
      expect(mail.body.encoded).to match(user.nickname)
    end

    it 'assigns @url' do
      expect(mail.body.encoded).to match('http://google.com')
    end
  end

  describe 'friendship_confirmation_email' do
    subject(:mail) { FriendshipMailer.with(user: sender).friendship_confirmation_email(friendship) }

    let(:sender) { create(:user) }
    let(:receiver) { create(:user) }
    let(:friendship) { create(:friendship, sender:, receiver:) }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('mailer.accept_email_subject', app_name: ApplicationMailer::APP_NAME))
    end

    it 'renders the email of user which receiver email' do
      expect(mail.to).to eq([sender.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end
  end

  describe 'friendship_declined_email' do
    subject(:mail) { FriendshipMailer.with(user: sender).friendship_declined_email(friendship_info) }

    let(:sender) { create(:user) }
    let(:receiver) { create(:user) }
    let(:friendship) { create(:friendship, sender:, receiver:) }
    let(:friendship_info) do
      {
        sender_nickname: friendship.sender.nickname,
        receiver_nickname: friendship.receiver.nickname,
        email: friendship.sender.email
      }
    end

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('mailer.declined_email_subject', app_name: ApplicationMailer::APP_NAME))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([sender.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'assigns @url' do
      expect(mail.body.encoded).to match('http://google.com')
    end

    it 'renders nickname of the user who declined your request' do
      expect(mail.body.encoded).to match(receiver.nickname)
    end

    it 'renders date when the request was declined' do
      expect(mail.body.encoded).to match(DateTime.now.strftime('%d.%m.%Y at %H:%M'))
    end
  end

  describe 'friend_request_email' do
    subject(:mail) { FriendshipMailer.with(user: sender).friend_request_email(*friendship_with_token.values) }

    let(:sender) { create(:user) }
    let(:receiver) { create(:user) }
    let(:friendship_with_token) do
      { friendship: create(:friendship, sender:, receiver:),
        token: 'example_token' }
    end

    before do
      allow(FriendshipTokenService).to receive(:new).and_return(token_service = double)
      allow(token_service).to receive(:generate_token).with(friendship_with_token[:friendship].id)
        .and_return(friendship_with_token[:token])
    end

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('mailer.new_friend_request_email_subject',
                                        app_name: ApplicationMailer::APP_NAME))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([receiver.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'assigns @url' do
      expect(mail.body.encoded).to match(FriendshipMailer::MY_FRIENDS_PAGE_URL)
    end

    it 'assigns @accept_url' do
      expect(mail.body.encoded).to include(friendship_with_token[:token])
    end

    it 'assigns @decline_url' do
      expect(mail.body.encoded).to include('status=decline')
    end

    it 'renders date when the request was submitted' do
      expect(mail.body.encoded).to match(friendship_with_token[:friendship].created_at.strftime('%d.%m.%Y at %H:%M'))
    end
  end

  describe 'reconnect_invitation_email' do
    subject(:mail) { FriendshipMailer.with(user:).reconnect_invitation_email(user, friend) }

    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    it 'renders the subject' do
      expect(mail.subject).to eq(I18n.t('mailer.reconnection_invitation_email_subject',
                                        app_name: ApplicationMailer::APP_NAME))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([friend.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['from@example.com'])
    end

    it 'assigns @user.nickname' do
      expect(mail.body.encoded).to match(user.nickname)
    end

    it 'assigns @friend.nickname' do
      expect(mail.body.encoded).to match(friend.nickname)
    end

    it 'assigns @url' do
      expect(mail.body.encoded).to match('http://google.com')
    end
  end
end
