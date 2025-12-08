# frozen_string_literal: true

ActiveAdmin.register Artist do
  menu label: 'Artists'
  permit_params :name

  filter :name
  filter :songs
  filter :created_at

  index do
    id_column
    column :name
    column 'Songs' do |artist|
      ul do
        artist.songs.includes(:album).each do |song|
          li song.title
        end
      end
    end
    column 'Albums' do |artist|
      ul do
        artist.songs.includes(:album).map(&:album).each do |album|
          li album.title
        end
      end
    end
    actions
  end

  form do |f|
    f.inputs 'Artist Details' do
      f.input :name
    end
    f.actions
  end
end
