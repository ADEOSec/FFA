class AddColumnToIncorrectLimitToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :incorrect_limit, :integer, default: -1
  end
end
