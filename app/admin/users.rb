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

  show do |user|
    attributes_table do
      row :user_name
      row :email
      row :group
      row :approved
      row :remember_created_at if user.remember_created_at
      row :reset_password_token if user.reset_password_token
      row :reset_password_sent_at if user.reset_password_sent_at
      row :sign_in_count
      row :last_sign_in_ip
      row :current_sign_in_ip
      row :last_sign_in_at
      row :failed_attempts if user.failed_attempts > 0
      row :locked_at if user.locked_at
      row :unlock_token if user.unlock_token
      row :current_sign_in_at
      row :confirmation_token unless user.confirmation_token
      row :confirmation_sent_at unless user.confirmation_token
      row :confirmed_at if user.confirmation_token
      row :admin_user_id if user.admin_user_id
    end

    active_admin_comments
  end

  filter :user_name
  filter :group
  filter :email
  filter :approved
end
