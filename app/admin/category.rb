ActiveAdmin.register Category do

  permit_params :name, :group_id

  before_create do |category|
    category.admin_user = current_admin_user
  end

  before_update do |category|
    category.admin_user = current_admin_user
  end

  index do
    selectable_column
    id_column
    column :group_id
    column :name
    actions
  end

  form do |f|
    f.inputs 'Kategori Detayları' do
      f.input :group
      f.input :name
    end

    f.actions
  end

  filter  :group
  filter  :admin_user, :collection => proc { AdminUser.all.pluck(:user_name, :id) }
end
