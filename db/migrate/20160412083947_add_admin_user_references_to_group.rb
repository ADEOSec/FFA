class AddAdminUserReferencesToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :admin_user, index: true, foreign_key: true
  end
end
