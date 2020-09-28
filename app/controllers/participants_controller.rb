class ParticipantsController < ApplicationController

  def index
    @participants = Participant.all
  end

  def show
    @participant = Participant.find(params[:id])
  end

  def new
    @participant = Participant.new
  end

  def edit
    @participant = Participant.find(params[:id])
  end

  def create
    @participant = Participant.new(participant_params)
    if @participant.save
      redirect_to @participant
    else
      render 'new'
    end
  end

  def update
    @participant = Participant.find(params[:id])
    if @participant.update(participant_params)
      redirect_to @participant
    else
      render 'edit'
    end
  end

  def destroy
    @participant = Participant.find(params[:id])
    @participant.destroy
    redirect_to participants_path
  end

  private

    def participant_params
      params.require(:participant).permit(:name, :role, :resume, :email)
    end

end
