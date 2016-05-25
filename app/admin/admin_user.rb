ActiveAdmin.register AdminUser do
  permit_params do
    params = [:email, :password, :password_confirmation, :user_name]

    if current_admin_user.is_super?
      params.push admin_user_group_attributes: [:id, :_destroy, :group_id]
      params.push :is_super
    end

    params
  end


  index do
    selectable_column
    id_column
    column :user_name
    column :email
    column :admin_user_group do |au|
      au.admin_user_group.group.name unless au.admin_user_group.nil?
    end
    actions
  end

  filter :email
  filter :user_name

  form do |f|
    f.inputs 'Admin Details' do
      f.input :user_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :is_super
    end

    f.inputs 'Admin Grubu', for: [:admin_user_group, f.object.admin_user_group || AdminUserGroup.new] do |aug|
      aug.input :group, include_blank: false
    end

    f.actions
  end

end
