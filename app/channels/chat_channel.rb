class ChatChannel < ApplicationCable::Channel
  def subscribed
    @user = User.find(user_id)
    stream_for @user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def user_id
    unless params[:user_id]
      reject
      raise ActionController::ParameterMissing, "User Id not provided"
    end

    params[:user_id]
  end
end
