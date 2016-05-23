# == Schema Information
#
# Table name: answer_texts
#
#  id            :integer          not null, primary key
#  question_id   :integer
#  user_id       :integer
#  value         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  is_correct    :boolean          default(FALSE)
#  score         :integer
#  admin_user_id :integer
#

class AnswerText < ActiveRecord::Base
  belongs_to              :question
  belongs_to              :user
  belongs_to              :admin_user

  validates               :value,             length: { in: 1..65000 }
  validates               :is_correct,        inclusion: { in: [ true, false ] }
  validate                :score_control

  validates_associated    :question
  validates_associated    :user
  validates_associated    :admin_user

  before_save             :loofah_rules

  after_save              :correct_status
  after_update            :correct_update
  after_destroy           :correct_destroy

  private
  def loofah_rules
    self.value            = Loofah.fragment(self.value).scrub!(:escape) unless self.value.nil?
  end

  private
  def score_control
    unless self.score.nil?
      errors.add(:score, 'Verilen puan sorunun puanından yüksel olamaz') unless self.score >= 0 && self.score <= self.question.score
    end
  end

  private
  def correct_status
    Score.create!(question_id: self.question_id, user_id: self.user_id, score: self.score) if self.is_correct
  end

  private
  def correct_update
    entry = Score.where(question_id: self.question_id, user_id: self.user_id).first
    if self.is_correct
      entry.update( score: self.score )
    else
      entry.destroy
    end
  end

  private
  def correct_destroy
    Score.where(question_id: self.question_id, user_id: self.user_id).first.destroy
  end
end
