class AddIsCorrectToAnswerString < ActiveRecord::Migration
  def change
    add_column :answer_strings, :is_correct, :boolean, default: false
  end
end
