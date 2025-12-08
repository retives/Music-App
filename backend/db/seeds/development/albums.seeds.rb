# frozen_string_literal: true

def attach_album_cover(album)
  first_album_with_cover = Album.where.not(cover_data: nil).first
  if first_album_with_cover.present?
    cover = [first_album_with_cover.cover_data, nil].sample
    album.update(cover_data: cover)
  else
    image_file = Rails.public_path.join('uploads', 'album_default_image.png').open('rb')
    album.cover = image_file
    album.cover_derivatives! if album.cover.present?
    album.save
  end
end

ALBUMS.times do
  album = Album.create(title: FFaker::Music.album)
  attach_album_cover(album)
end
