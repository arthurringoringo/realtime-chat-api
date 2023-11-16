class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show update destroy ]

  # GET /chat_room/:id/messages
  def index
    raise ActionController::ParameterMissing unless params[:id]
    room_id = params[:id]
    @messages = Message.where(:room_id => room_id)

    render_json(@messages.to_a)
  end

  # GET /messages/1
  def show
    render json: @message
  end

  # POST /messages
  def create
    chat_room = ChatRoom.find(request_body[:room_id])
    @message = Message.new(
      text: request_body[:text],
      room_id: request_body[:room_id],
      sender_id: request_body[:sender_id]
    )

    if @message.save
      chat_room.chat_room_members.map(&:user).each do |user|
        # ActionCable.server.broadcast(user.username, @message.as_json)
        ChatChannel.broadcast_to(user, @message)
      end
      render_json(@message)
    else
      raise ActiveRecord::RecordInvalid
    end
  end

  # # PATCH/PUT /messages/1
  # def update
  #   if @message.update(message_params)
  #     render json: @message
  #   else
  #     render json: @message.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /messages/1
  # def destroy
  #   @message.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.fetch(:message, {})
    end
end
