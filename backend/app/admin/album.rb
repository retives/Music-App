# frozen_string_literal: true

ActiveAdmin.register Album do
  menu label: 'Albums'
  permit_params :title, :cover

  filter :title
  filter :cover
  filter :created_at
  filter :songs

  index do
    id_column
    column :title
    column :cover do |album|
      if album.cover.present?
        image_tag album.cover_url, width: 50
      else
        image_tag '/uploads/album_default_image.png', width: 50
      end
    end

    column 'Songs' do |album|
      ul do
        album.songs.includes(:artists).each do |song|
          li song.title
        end
      end
    end
    column 'Artist' do |album|
      ul do
        album.songs.first&.artists&.map(&:name)&.first
      end
    end
    actions
  end

  form do |f|
    f.inputs 'Album Details' do
      f.input :title
      f.input :cover, as: :file
    end
    f.actions
  end

  controller do
    def destroy
      album = Album.find(params[:id])
      album.songs.includes(:playlist_songs, :artists).each(&:destroy)
      album.destroy

      flash[:notice] = I18n.t('active_admin.flash.album_deleted')
      redirect_to admin_albums_path
    end
  end
end
