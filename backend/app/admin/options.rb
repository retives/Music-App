# frozen_string_literal: true

ActiveAdmin.register Option do
  permit_params :title, :handle, :body

  includes :rich_text_body

  before_create do |option|
    option.handle = option.handle.downcase
  end

  index do
    id_column
    column :title
    column :handle
    column :body do |option|
      option.body.to_plain_text
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :handle
      row :body do
        resource.body.to_plain_text
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :handle, required: true
      f.rich_text_area :body
    end
    f.actions
  end
end
