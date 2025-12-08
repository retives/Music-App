# frozen_string_literal: true

ActiveAdmin.register Song do
  includes :album, :genre, :artists

  menu label: 'Songs'
  permit_params :title, :album_id, :genre_id, artist_ids: []

  filter :title
  filter :album, as: :select, collection: proc { Album.all.collect { |album| [album.title, album.id] } }
  filter :artists, as: :select, collection: proc {
                                              Artist.all.map do |artist|
                                                [artist.name, artist.id]
                                              end
                                            }, input_html: { multiple: true }
  filter :genre, as: :select, collection: proc { Genre.all.collect { |genre| [genre.title, genre.id] } }
  filter :created_at
  filter :updated_at

  index do
    id_column
    column :title
    column 'Album' do |song|
      song.album.title
    end
    column 'Artists' do |song|
      song.artists.map(&:name)
    end
    column 'Genre' do |song|
      song.genre.title
    end
    actions
  end

  form do |f|
    f.inputs 'Song Details' do
      f.input :title
      f.input :album_id, as: :select, collection: Album.all.collect { |album| [album.title, album.id] }
      artist_collection = Artist.all.map { |artist| [artist.name, artist.id] }
      f.input :artist_ids, as: :select, collection: artist_collection, input_html: { multiple: true }
      f.input :genre_id, as: :select, collection: Genre.all.collect { |genre| [genre.title, genre.id] }
    end
    f.actions
  end
end
