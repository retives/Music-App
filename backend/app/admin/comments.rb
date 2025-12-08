# frozen_string_literal: true

ActiveAdmin.register Comment, as: 'PlaylistComment' do
  includes :user, :playlist
  actions :index, :show, :destroy

  menu label: 'Playlist Comments'

  filter :user_email, as: :select, collection: proc { User.distinct.pluck(:email) }
  filter :content
  filter :playlist_name, as: :select, collection: proc { Playlist.distinct.pluck(:name) }
  filter :created_at

  batch_action :destroy, confirm: false do |ids|
    comments = Comment.where(id: ids)
    comments.each(&:destroy)
    redirect_to admin_playlist_comments_path
  end

  index do
    selectable_column
    column :id
    column :user_email do |comment|
      comment.user&.email
    end
    column :content
    column :playlist_name do |comment|
      comment.playlist.name
    end
    column :created_at
    actions defaults: false do |comment|
      item I18n.t('active_admin.crud.view'), admin_playlist_comment_path(comment), class: 'view_link member_link'
      item I18n.t('active_admin.crud.delete'), admin_playlist_comment_path(comment), method: :delete,
                                                                                     data: { confirm: false },
                                                                                     class: 'delete_link member_link'
    end
  end

  config.action_items.delete_if { |item| item.name == :destroy && item.display_on?(:show) }

  action_item :destroy, only: %i[show] do
    link_to I18n.t('active_admin.crud.delete'), admin_playlist_comment_path(resource), method: :delete,
                                                                                       data: { confirm: false },
                                                                                       class: 'member_link delete_link'
  end
end
