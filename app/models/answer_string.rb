# == Schema Information
#
# Table name: answer_strings
#
#  id          :integer          not null, primary key
#  question_id :integer
#  user_id     :integer
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_correct  :boolean          default(FALSE)
#

class AnswerString < ActiveRecord::Base
  belongs_to              :question
  belongs_to              :user

  validates               :value,             presence: true

  validates_associated    :question
  validates_associated    :user

  before_save             :loofah_rules

  after_save              :correct_status
  after_update            :correct_update
  after_destroy           :correct_destroy

  private
  def loofah_rules
    self.value            = Loofah.fragment(self.value).scrub!(:escape)
  end

  private
  def correct_status
    Score.create!(question_id: self.question_id, user_id: self.user_id, score: self.question.score) if self.is_correct
  end

  private
  def correct_update
    Score.where(question_id: self.question_id, user_id: self.user_id).first.destroy unless self.is_correct
  end

  private
  def correct_destroy
    Score.where(question_id: self.question_id, user_id: self.user_id).first.destroy
  end
end
