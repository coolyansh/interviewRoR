class Interview < ApplicationRecord

  class InterviewValidator < ActiveModel::Validator
    def validate(record)

      interviewer_curr = Participant.find(record.interviewer_id)
      interviewee_curr = Participant.find(record.interviewee_id)
      interviews = Interview.where('interviewer_id = ? OR interviewee_id = ?',record.interviewer_id,record.interviewee_id)

      if record.start_time < DateTime.now()
        record.errors[:start_time] << "Inteview cannot be scheduled in past."
      end

      if record.start_time > record.end_time
        record.errors[:end_time] << 'End_time must be greater than start_time.'
      end

      if interviewer_curr.role == 'Interviewee'
        record.errors[:interviewer] << 'Interviewer assigned is an interviewee.'
      end

      if interviewee_curr.role == 'Interviewer'
        record.errors[:interviewee] << 'Interviewer assigned is an interviewer.'
      end

      interviews.each do |interview|
        if ((interview.start_time > record.start_time and interview.start_time < record.end_time) or
          (interview.end_time > record.start_time and interview.end_time < record.end_time) or
          (interview.start_time < record.start_time and interview.end_time > record.end_time))
          record.errors[:start_time] << 'Conflict with interview of one or more participants'
          break
        end
      end

    end
  end

  belongs_to :interviewer, class_name: 'Participant'
  belongs_to :interviewee, class_name: 'Participant'

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates_with InterviewValidator
end
