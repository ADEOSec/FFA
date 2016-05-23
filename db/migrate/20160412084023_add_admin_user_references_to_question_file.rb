class AddAdminUserReferencesToQuestionFile < ActiveRecord::Migration
  def change
    add_reference :question_files, :admin_user, index: true, foreign_key: true
  end
end
