class AddAdminUserReferencesToCategory < ActiveRecord::Migration
  def change
    add_reference :categories, :admin_user, index: true, foreign_key: true
  end
end
