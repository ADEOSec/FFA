# == Schema Information
#
# Table name: groups
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  admin_user_id :integer
#

class Group < ActiveRecord::Base
  belongs_to              :admin_user

  has_many                :users,               dependent: :destroy
  has_many                :categories,          dependent: :destroy

  validates               :name,                presence: true

  validates_associated    :admin_user

  before_save             :loofah_rules

  private
  def loofah_rules
    self.name             = Loofah.fragment(self.name).scrub!(:escape)
  end
end
