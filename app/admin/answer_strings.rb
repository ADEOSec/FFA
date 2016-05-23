ActiveAdmin.register AnswerString do
  actions :index, :show

  index do
    id_column
    column :question do |as|
      link_to as.question_id, admin_question_path(as.question_id)
    end
    column :user do |as|
     link_to as.user.user_name, admin_user_path(as.user)
    end
    column :is_correct
    column :created_at
    actions
  end

  filter :question
  filter :user, :collection => proc { User.all.pluck(:user_name, :id) }
  filter :is_correct
  filter :created_at

end
