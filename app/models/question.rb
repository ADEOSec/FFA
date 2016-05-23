# == Schema Information
#
# Table name: questions
#
#  id              :integer          not null, primary key
#  category_id     :integer
#  title           :string
#  content         :text
#  score           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  question_type   :integer          default(1)
#  admin_user_id   :integer
#  incorrect_limit :integer          default(-1)
#

class Question < ActiveRecord::Base
  belongs_to              :category
  belongs_to              :admin_user

  has_many                :question_keys,       dependent: :destroy
  has_many                :question_files,      dependent: :destroy
  has_many                :answer_strings,      dependent: :destroy
  has_many                :answer_texts,        dependent: :destroy

  validates               :title,               presence: true
  validates               :content,             presence: true
  validates               :score,               presence: true
  validates               :question_type,       presence: true,                     inclusion: { in: [1, 2] }

  validates_associated    :admin_user
  validates_associated    :category

  before_save             :loofah_rules

  accepts_nested_attributes_for   :question_keys,       allow_destroy: true
  accepts_nested_attributes_for   :question_files,      allow_destroy: true

  private
  def loofah_rules
    self.title            = Loofah.fragment(self.title).scrub!(:escape)
    self.content          = Loofah.fragment(self.content).scrub!(:escape)
  end
end
