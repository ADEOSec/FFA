class AddAdminUserReferencesToUser < ActiveRecord::Migration
  def change
    add_reference :users, :admin_user, index: true, foreign_key: true
  end
end
