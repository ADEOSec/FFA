class AddQuestionTypeToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :question_type, :integer, default: 1
  end
end
