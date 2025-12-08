# frozen_string_literal: true

after 'development:users' do
  users = User.all.order(:id)
  main_user = User.first
  senders = users[1..5]
  receivers = users[6..10]

  senders.each_with_index do |sender, i|
    Friendship.create(sender_id: sender.id, receiver_id: main_user.id, status: i % 2)
  end

  receivers.each_with_index do |receiver, i|
    Friendship.create(sender_id: main_user.id, receiver_id: receiver.id, status: i % 2)
  end
end
