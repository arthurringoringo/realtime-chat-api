class ChatRoomsController < ApplicationController
  before_action :set_chat_room, only: %i[ show update destroy ]

  # GET /chat_rooms
  def index
    @chat_rooms = ChatRoom.all

    render_json(@chat_rooms)
  end

  # GET /chat_rooms/1
  def show
    render_json(@chat_room)
  end

  # POST /chat_rooms
  def create
    @chat_room = ChatRoom.new(name: request_body[:name],created_by_id: request_body[:user_id] )

    if @chat_room.save
      render_json(@chat_room)
    else
      raise ActiveRecord::RecordInvalid
    end
  end

  def join
    @chat_room = ChatRoom.find!(request_body[:room_id])
    is_member = @chat_room.chat_room_members.users.find!(request_body[:user_id])
    if is_member
      render_json(@chat_room)
    else
      @chat_room.chat_room_members.create!(user_id: request_body[:user_id])
      render_json(@chat_room)
    end
  end

  # PATCH/PUT /chat_rooms/1
  def update
    if @chat_room.update(name: request_body[:name])
      render_json(@chat_room)
    else
      raise ActiveRecord::RecordInvalid
    end
  end

  # DELETE /chat_rooms/1
  def destroy
    @chat_room.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_room
      @chat_room = ChatRoom.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
end
