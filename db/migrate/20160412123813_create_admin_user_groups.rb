class CreateAdminUserGroups < ActiveRecord::Migration
  def change
    create_table :admin_user_groups do |t|
      t.references :admin_user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
