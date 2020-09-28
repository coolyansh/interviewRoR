class InterviewMailer < ApplicationMailer

  def new_interview_email
    @interview = params[:interview]
    begin
      mail(to: [@interview.interviewer.email,@interview.interviewee.email], subject: "Interview successfully created.")
    rescue
      puts "Some problem occured while sending mail for new interview."
    end
  end

  def update_interview_email
    @interview = params[:interview]
    begin
      mail(to: [@interview.interviewer.email,@interview.interviewee.email], subject: "Interview updated successfully.")
    rescue
      puts "Some problem occured while sending mail for updated interview."
    end

  end

  def reminder_interview_email
    @interview = params[:interview]
    @interview_curr = Interview.find(@interview.id)
    begin
      if @interview.start_time == @interview_curr.start_time
        mail(to: [@interview.interviewer.email,@interview.interviewee.email], subject: "Reminder for scheduled Interview")
      else
        puts "Email not send as interview details had been updated."
      end
    rescue
      puts "Some problem occured in sending reminder mail."
    end
  end

end
