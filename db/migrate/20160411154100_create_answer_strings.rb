class CreateAnswerStrings < ActiveRecord::Migration
  def change
    create_table :answer_strings do |t|
      t.references :question, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :value

      t.timestamps null: false
    end
  end
end
