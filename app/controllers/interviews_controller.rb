class InterviewsController < ApplicationController

  def index
    @interviews = Interview.all.includes(:interviewer,:interviewee)
  end

  def show
    @interview = Interview.includes(:interviewer,:interviewee).find(params[:id])
  end

  def new
    @interview = Interview.new
    @interviewers , @interviewees = getParticipants
  end

  def edit
    @interview = Interview.find(params[:id])
    @interviewers , @interviewees = getParticipants
  end

  def create
    @interview = Interview.new(interview_params)
    if @interview.save
      InterviewMailer.with(interview: @interview).new_interview_email.deliver_later
      if @interview.start_time - 30.minutes > DateTime.now
        InterviewMailer.with(interview: @interview).reminder_interview_email.deliver_later(wait_until: @interview.start_time - 6.hours)
      end
      redirect_to @interview
    else
      @interviewers , @interviewees = getParticipants
      render 'new'
    end
  end

  def update
    @interview = Interview.find(params[:id])
    if @interview.update(interview_params)
      InterviewMailer.with(interview: @interview).update_interview_email.deliver_later
      if @interview.start_time - 30.minutes > DateTime.now
        InterviewMailer.with(interview: @interview).reminder_interview_email.deliver_later(wait_until: @interview.start_time - 6.hours)
      end
      redirect_to @interview
    else
      @interviewers , @interviewees = getParticipants
      render 'edit'
    end
  end

  def destroy
    @interview = Interview.find(params[:id])
    @interview.destroy
    redirect_to interviews_path
  end

  private
    def interview_params
      params.require(:interview).permit(:interviewer_id, :interviewee_id, :start_time, :end_time)
    end

    def getParticipants
      participants = Participant.all
      interviewers=[]
      interviewees=[]
      participants.each do |participant|
        if participant.role == 'Interviewer'
          interviewers.append([participant.name,participant.id])
        else
          interviewees.append([participant.name,participant.id])
        end
      end
      return interviewers,interviewees
    end
end
