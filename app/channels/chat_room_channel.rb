class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from room_id
    ActionCable.server.broadcast(room_id, "Connected to room #{room_id}")
  end

   def unsubscribed

   end

  private

  def room_id
    unless params[:room_id]
      reject
      raise ActionController::ParameterMissing "Room ID not provided"
    end
    params[:room_id]
  end
end