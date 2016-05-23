class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(User)
      can       :read,    Question,           category: { group_id: user.group_id }
      can       :answer,  Question,           category: { group_id: user.group_id }
    elsif user.is_a?(AdminUser)
      if user.is_super
        can     :manage,  :all
      else
        can     :read,    ActiveAdmin::Page,  name: 'Dashboard'
        can     :manage,  Question,           Question.all do |question|
          if question.category_id.nil?
            true
          elsif question.category.group_id == user.admin_user_group.group_id
            true
          else
            false
          end
        end
        can     :read,    AnswerString,       AnswerString.all do |answer_string|
          if answer_string.question.category.group_id == user.admin_user_group.group_id
            true
          else
            false
          end
        end
        can     :manage,  AnswerText,         AnswerText.all do |answer_text|
          if answer_text.question.category.group_id == user.admin_user_group.group_id
            true
          else
            false
          end
        end
        can     :manage,  AdminUser,          id: user.id
        can     :manage,  Category,           Category.all do |category|
          if category.group_id.nil?
            true
          elsif category.group_id == user.admin_user_group.group_id
            true
          else
            false
          end
        end
      end
    else
      cannot  :all,   :all
    end
  end
end
