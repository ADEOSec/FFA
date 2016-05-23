# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  group_id      :integer
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  admin_user_id :integer
#

class Category < ActiveRecord::Base
  belongs_to              :group
  belongs_to              :admin_user

  has_many                :questions,         dependent: :destroy

  validates               :name,              presence: true

  validates_associated    :admin_user
  validates_associated    :group

  before_save             :loofah_rules

  private
  def loofah_rules
    self.name            = Loofah.fragment(self.name).scrub!(:escape)
  end
end
