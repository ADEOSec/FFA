class AddColumnGroupToAdminUser < ActiveRecord::Migration
  def change
    add_reference :admin_users, :group, index: true, foreign_key: true
    add_column :admin_users, :is_super, :boolean, default: false
  end
end
