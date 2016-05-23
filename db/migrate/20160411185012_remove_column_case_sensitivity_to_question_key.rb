class RemoveColumnCaseSensitivityToQuestionKey < ActiveRecord::Migration
  def change
    remove_column :question_keys, :case_sensitivity, :boolean
  end
end
