ActiveAdmin.register AnswerText do
  actions :index, :show, :edit, :update

  permit_params :is_correct, :score


  before_create do |answer_text|
    answer_text.admin_user = current_admin_user
  end

  before_update do |answer_text|
    answer_text.admin_user = current_admin_user
  end

  index do
    selectable_column
    id_column
    column :question do |as|
      link_to as.question_id, admin_question_path(as.question_id)
    end
    column :user do |at|
      link_to at.user.user_name, admin_user_path(at.user)
    end
    column :is_correct
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :score
      f.input :is_correct
    end

    f.actions
  end

  filter :question
  filter :user,       :collection => proc { User.all.pluck(:user_name, :id) }
  filter :is_correct

end
