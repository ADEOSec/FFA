class CreateAnswerTexts < ActiveRecord::Migration
  def change
    create_table :answer_texts do |t|
      t.references :question, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :value

      t.timestamps null: false
    end
  end
end
