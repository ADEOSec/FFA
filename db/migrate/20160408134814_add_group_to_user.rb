class AddGroupToUser < ActiveRecord::Migration
  def change
    add_reference :users, :group, index: true, foreign_key: true
  end
end
