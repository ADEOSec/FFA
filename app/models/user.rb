# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  user_name              :string           not null
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
#  approved               :boolean          default(FALSE), not null
#  group_id               :integer
#  admin_user_id          :integer
#  unique_session_id      :string(20)
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :session_limitable

  belongs_to            :group
  belongs_to            :admin_user

  has_many              :answer_strings,      dependent: :destroy
  has_many              :answer_texts,        dependent: :destroy
  has_many              :logs,                dependent: :destroy

  validates             :email,               presence: true
  validates             :user_name,           presence: true,       uniqueness: true

  validates_associated  :admin_user
  validates_associated  :group

  before_save           :loofah_rules

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t('devise.failure.not_approved')
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  private
  def loofah_rules
    self.email      = Loofah.fragment(self.email).scrub!(:escape)
    self.user_name  = Loofah.fragment(self.user_name).scrub!(:escape)
  end
end
