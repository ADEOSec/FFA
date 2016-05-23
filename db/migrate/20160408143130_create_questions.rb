class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :category, index: true, foreign_key: true
      t.string :title
      t.text :content
      t.integer :score

      t.timestamps null: false
    end
  end
end
