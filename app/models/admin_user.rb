# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_super               :boolean          default(FALSE)
#  user_name              :string
#

class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to                    :group

  has_one                       :admin_user_group,    dependent: :destroy

  validates                     :email,               presence: true
  validates                     :user_name,           presence: true

  accepts_nested_attributes_for :admin_user_group


  before_save                   :loofah_rules

  private
  def loofah_rules
    self.email      = Loofah.fragment(self.email).scrub!(:escape)
    self.user_name  = Loofah.fragment(self.user_name).scrub!(:escape)
  end
end