# == Schema Information
#
# Table name: logs
#
#  id         :integer          not null, primary key
#  activity   :string
#  user_id    :integer
#  user_agent :string
#  ip         :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Log < ActiveRecord::Base
  belongs_to :user
end
