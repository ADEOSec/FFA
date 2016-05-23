ActiveAdmin.register Group do
  permit_params :name

  before_create do |group|
    group.admin_user = current_admin_user
  end

  before_update do |group|
    group.admin_user = current_admin_user
  end

  form do |f|
    f.inputs 'Grup Bilgileri' do
      f.input :name
    end

    f.actions
  end

  index do |f|
    selectable_column
    id_column
    column :name
    column :admin_user
    actions
  end
end
