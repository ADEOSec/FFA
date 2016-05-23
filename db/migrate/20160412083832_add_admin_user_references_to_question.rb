class AddAdminUserReferencesToQuestion < ActiveRecord::Migration
  def change
    add_reference :questions, :admin_user, index: true, foreign_key: true
  end
end
