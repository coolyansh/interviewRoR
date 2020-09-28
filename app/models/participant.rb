class Participant < ApplicationRecord

  has_many :interviews_to_take, class_name: 'Interview', foreign_key: 'interviewer_id', dependent: :destroy
  has_many :interviews_to_give, class_name: 'Interview', foreign_key: 'interviewee_id', dependent: :destroy

  has_attached_file :resume
  validates_attachment_content_type :resume, content_type: 'application/pdf'
  validates_attachment :resume, presence: true, if: :is_interviewee
  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: [ "Interviewer", "Interviewee"], message: "%{value} is not a valid value for role" }

  def is_interviewee
    role == "Interviewee"
  end
end
