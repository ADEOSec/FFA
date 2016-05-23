class RemoveGroupReferencesToAdminUser < ActiveRecord::Migration
  def change
    remove_reference :admin_users, :group, index: true, foreign_key: true
  end
end
