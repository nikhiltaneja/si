class MessagesController < ApplicationController

  def show
    @message = Message.where(message_id: params[:message_id])
  end

  def inbox
    @user = User.find(params[:user_id])
    @messages = Message.where(receiver_id: @user.id).page(params[:page]).per(10)
    
  end

  def sent
    @user = User.find(params[:user_id])
    @messages = Message.where(sender_id: @user.id).page(params[:page]).per(10)
  end

  def create
    @match = Match.find(params[:match_id])
    message_params = params.require(:message).permit(:title, :body)
    receiver_id = current_user.id == @match.first_user_id ? @match.second_user_id : @match.first_user_id
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    @message.receiver_id = receiver_id
    @message.match_id = params[:match_id].to_i
    if @message.save
      redirect_to root_path, notice: "Message Sent!"
    else 
      render :new
    end
  end
end
