# frozen_string_literal: true

def unique_nickname
  nickname_item = FFaker::InternetSE.user_name_random
  nickname_item = FFaker::InternetSE.user_name_random while User.exists?(nickname: nickname_item)
  nickname_item
end

def attach_profile_picture(user)
  first_user_with_profile_pict = User.where.not(profile_picture_data: nil).first
  if first_user_with_profile_pict.present?
    profile_picture = [first_user_with_profile_pict.profile_picture_data, nil].sample
    user.update(profile_picture_data: profile_picture)
  else
    image_file = Rails.public_path.join('uploads', 'user_default_image.png').open('rb')
    user.profile_picture = image_file
    user.profile_picture_derivatives! if user.profile_picture.present?
    user.save
  end
end

# base user
User.create(
  email: 'test.user@example.com',
  nickname: unique_nickname,
  password: 'secreT!123',
  timezone: 'Kyiv'
)

# other users
USERS.times do
  User.create(
    email: FFaker::Internet.email,
    nickname: unique_nickname,
    password: 'secreT!123',
    timezone: FFaker::Address.time_zone
  )
end

User.find_each do |user|
  attach_profile_picture(user)
end

# admin user
AdminUser.create(
  email: 'admin@example.com',
  nickname: 'Admin',
  password: 'secreT!123'
)
