# == Schema Information
#
# Table name: question_keys
#
#  id            :integer          not null, primary key
#  question_id   :integer
#  value         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  admin_user_id :integer
#

class QuestionKey < ActiveRecord::Base
  using TurkishSupport

  belongs_to                        :question
  belongs_to                        :admin_user

  validates                         :value,                presence: true

  validates_associated              :admin_user
  validates_associated              :question

  before_save                       :downcase_keys_and_loofah_rules

  private
  def downcase_keys_and_loofah_rules
    self.value                      = self.value.downcase
    self.value                      = Loofah.fragment(self.value).scrub!(:escape)
  end
end
