# == Schema Information
#
# Table name: scores
#
#  id          :integer          not null, primary key
#  question_id :integer
#  user_id     :integer
#  score       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Score < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
end
