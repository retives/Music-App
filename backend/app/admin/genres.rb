# frozen_string_literal: true

ActiveAdmin.register Genre do
  actions :index, :create, :new

  menu label: 'Genres'
  permit_params :title

  filter :title
  filter :created_at
  filter :updated_at

  index do
    id_column
    column :title
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs 'Genre Details' do
      f.input :title
    end
    f.actions
  end
end
