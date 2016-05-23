class CreateQuestionFiles < ActiveRecord::Migration
  def change
    create_table :question_files do |t|
      t.references :question, index: true, foreign_key: true
      t.attachment :file

      t.timestamps null: false
    end
  end
end
