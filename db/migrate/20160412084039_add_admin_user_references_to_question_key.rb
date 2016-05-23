class AddAdminUserReferencesToQuestionKey < ActiveRecord::Migration
  def change
    add_reference :question_keys, :admin_user, index: true, foreign_key: true
  end
end
