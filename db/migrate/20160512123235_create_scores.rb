class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.references :question, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :score

      t.timestamps null: false
    end
  end
end
