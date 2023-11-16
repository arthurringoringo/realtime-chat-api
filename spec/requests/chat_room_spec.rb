require 'rails_helper'

RSpec.describe "ChatRooms", type: :request do

  before do
    @user1 = User.create!(username: "arthur")
    @user2 = User.create!(username: "juan")
    @user3 = User.create!(username: "michale")
    @chat_room_1 = ChatRoom.create!(name:"arthur's chat room", created_by: @user1)
    @chat_room_2 = ChatRoom.create!(name:"juan's chat room", created_by: @user2)
  end

  describe "GET" do
    it "return ok and all available chat room" do
      get_json "/chat_rooms", {}, {}
      expect_response(
        :ok,
        [
          {
            id: @chat_room_1.id,
            name: @chat_room_1.name,
            created_by_id: @user1.id,
          },
          {
            id: @chat_room_2.id,
            name: @chat_room_2.name,
            created_by_id: @user2.id,
          }
        ]
      )
    end

    it "return ok and show details of a chat room" do
      get_json "/chat_rooms/#{@chat_room_1.id}", {}, {}
      expect_response(
        :ok,
        {
          id: @chat_room_1.id,
          name: @chat_room_1.name,
          created_by: @user1.username,
          created_at: @chat_room_1.created_at.to_s,
          room_members: [
            {id: @user1.id, username: @user1.username}
          ]
        }
      )
    end

    it "return error when non existent room called" do
      get_json "/chat_rooms/123123123", {}, {}
      expect_response(:not_found, {error: "ChatRoom not found"})
    end

  end

  describe "POST & PATCH" do

    it "return ok when create a chat room" do
      post_json "/chat_rooms", {name: "michael's chat room",user_id: @user3.id}, {}
      expect_response(:ok, {id: Integer, name: "michael's chat room", created_by_id: @user3.id})
      chat_room = ChatRoom.find(response_body[:id])
      expect(chat_room).to be_truthy
      expect(chat_room.chat_room_members.count).to be(1)
    end

    it "return error when fail to save" do
      post_json "/chat_rooms", {nae: "michael's chat room",user_id: @user3.id}, {}
      expect_response(:unprocessable_entity, {error: "Record invalid"})
    end

    it "return ok when joining a chat room" do
      post_json "/chat_rooms/join/#{@chat_room_1.id}", {user_id: @user3.id},{}
      expect_response(:ok,{id: @chat_room_1.id})
      get_json "/chat_rooms/#{@chat_room_1.id}", {}, {}
      expect_response(:ok, { room_members: [{id: @user1.id},{id: @user3.id}]})
    end

    it "return ok when joining a already joined chat room" do
      post_json "/chat_rooms/join/#{@chat_room_1.id}", {user_id: @user1.id},{}
      expect_response(:ok,{id: @chat_room_1.id})
      get_json "/chat_rooms/#{@chat_room_1.id}", {}, {}
      expect_response(:ok, { room_members: [{id: @user1.id}]})
    end

    it "return error when joining a nonexistent chat room" do
      post_json "/chat_rooms/join/#{@chat_room_1.id+99}", {user_id: @user1.id},{}
      expect_response(:not_found, {error: "ChatRoom Not Found"})
    end

    it "return ok when updating a chat room" do
      patch_json "/chat_rooms/#{@chat_room_2.id}", {name: "Updated Name"}, {}
      expect_response(:ok, {name: "Updated Name"})
    end
  end

  describe "DELETE" do
    it "return ok when delete a chat room" do
      delete_json "/chat_rooms/#{@chat_room_1.id}", {}, {}
      expect_response(:ok, {id: @chat_room_1.id})
      expect{ ChatRoom.find(response_body[:id])}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
