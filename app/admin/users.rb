ActiveAdmin.register User do
  permit_params :approved, :group_id, :user_name, :email, :password, :password_confirmation

  before_create do |user|
    user.admin_user_id = current_admin_user
  end

  before_update do |user|
    user.admin_user_id = current_admin_user
  end

  index do
    selectable_column
    id_column
    column :user_name
    column :email
    column :group_id
    column :approved
    column :current_sign_in_ip
    actions
  end

  form do |f|
    f.inputs 'Kullanıcı Düzenleme Ekranı' do
      f.input :user_name
      f.input :email
      f.input :group
      f.input :approved
      f.input :password
      f.input :password_confirmation
    end

    f.actions
  end

  filter :user_name
  filter :group_id
  filter :email
  filter :approved
end
