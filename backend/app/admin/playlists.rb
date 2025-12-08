# frozen_string_literal: true

ActiveAdmin.register Playlist do
  decorate_with PlaylistDecorator
  actions :all, except: %w[destroy new]

  menu label: 'Playlists'
  permit_params :featured

  filter :name
  filter :playlist_type, as: :select, collection: Playlist.playlist_types.values.map(&:to_sym)
  filter :created_at
  filter :updated_at
  filter :featured

  index do
    id_column
    column :name
    column :description
    column :playlist_type
    column :logo do |playlist|
      if playlist.logo.present?
        image_tag playlist.logo_url, width: 50
      else
        image_tag '/uploads/default_image.jpg', width: 50
      end
    end
    column :created_at
    column :updated_at
    column :featured
    column do |playlist|
      link_to I18n.t('active_admin.crud.view'), admin_playlist_path(playlist), class: 'view_link'
    end
    actions defaults: false do |playlist|
      if playlist.open_playlist_type?
        item I18n.t('active_admin.crud.edit'), edit_admin_playlist_path(playlist), class: 'edit_link'
      end
    end
  end

  config.action_items.delete_if { |item| item.name == :edit && item.display_on?(:show) }

  action_item :edit, only: :show do
    link_to I18n.t('active_admin.crud.edit'), edit_admin_playlist_path(playlist) if playlist.open_playlist_type?
  end

  form do |f|
    f.inputs :featured if playlist.open_playlist_type?
    f.actions
  end
end
