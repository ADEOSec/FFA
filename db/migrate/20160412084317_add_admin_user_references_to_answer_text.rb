class AddAdminUserReferencesToAnswerText < ActiveRecord::Migration
  def change
    add_reference :answer_texts, :admin_user, index: true, foreign_key: true
  end
end
