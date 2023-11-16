class ChatRoomsController < ApplicationController
  before_action :set_chat_room, only: %i[ show update destroy join ]

  # GET /chat_rooms
  def index
    @chat_rooms = ChatRoom.all

    render_json(@chat_rooms)
  end

  # GET /chat_rooms/1
  def show
    users = []
    @chat_room.chat_room_members.each do |member|
      users << { id:member.user.id, username: member.user.username, joined_at: member.created_at }
    end
    response = {
      id: @chat_room.id,
      name: @chat_room.name,
      created_by: @chat_room.created_by.username,
      created_at: @chat_room.created_at.strftime("%F %T %Z"),
      room_members: users
    }
    render_json(response)
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
    is_member = @chat_room.chat_room_members.where(user_id: request_body[:user_id])
    unless is_member.empty?
      render_json(@chat_room)
    else
      @chat_room.chat_room_members.create!(user_id: request_body[:user_id])
      render_json(@chat_room)
    end
  end

  # PATCH/PUT /chat_rooms/1
  def update
    if @chat_room.update!(name: request_body[:name])
      render_json(@chat_room)
    else
      raise ActiveRecord::RecordInvalid
    end
  end

  # DELETE /chat_rooms/1
  def destroy
    status = @chat_room.destroy
    render_json(status)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_room
      @chat_room = ChatRoom.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
end
