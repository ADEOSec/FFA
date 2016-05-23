# == Schema Information
#
# Table name: admin_user_groups
#
#  id            :integer          not null, primary key
#  admin_user_id :integer
#  group_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class AdminUserGroup < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :group
end
