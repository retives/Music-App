# frozen_string_literal: true

def unique_nickname
  nickname_item = FFaker::InternetSE.user_name_random
  nickname_item = FFaker::InternetSE.user_name_random while User.exists?(nickname: nickname_item)
  nickname_item
end

# base user
User.create(
  email: 'test.user@example.com',
  nickname: unique_nickname,
  password: 'secreT!123',
  timezone: 'Kyiv',
  profile_picture_data: nil
)

# other users
USERS.times do
  User.create(
    email: FFaker::Internet.email,
    nickname: unique_nickname,
    password: 'secreT!123',
    timezone: FFaker::Address.time_zone,
    profile_picture_data: nil
  )
end

# admin user
AdminUser.create(
  email: 'admin@example.com',
  nickname: 'Admin',
  password: 'secreT!123'
)
