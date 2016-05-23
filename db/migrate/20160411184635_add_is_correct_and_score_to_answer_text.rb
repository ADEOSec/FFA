class AddIsCorrectAndScoreToAnswerText < ActiveRecord::Migration
  def change
    add_column :answer_texts, :is_correct, :boolean, default: false
    add_column :answer_texts, :score, :integer
  end
end
