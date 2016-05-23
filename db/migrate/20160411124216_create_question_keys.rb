class CreateQuestionKeys < ActiveRecord::Migration
  def change
    create_table :question_keys do |t|
      t.references :question, index: true, foreign_key: true
      t.string :value
      t.boolean :case_sensitivity

      t.timestamps null: false
    end
  end
end
