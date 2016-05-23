# == Schema Information
#
# Table name: question_files
#
#  id                :integer          not null, primary key
#  question_id       :integer
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  admin_user_id     :integer
#

class QuestionFile < ActiveRecord::Base
  belongs_to                        :question
  belongs_to                        :admin_user


  validates_associated              :admin_user
  validates_associated              :question

  has_attached_file                 :file
  validates_attachment_content_type :file,                  content_type: /\Aapplication\/zip\Z/
  validates_attachment_file_name    :file,                  matches: [/zip\Z/]

  before_save                       :loofah_rules

  private
  def loofah_rules
    self.file_file_name             = Loofah.fragment(self.file_file_name).scrub!(:escape)
  end
end
