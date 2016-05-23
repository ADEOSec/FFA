class AddColumnUserNameToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :user_name, :string
  end
end
