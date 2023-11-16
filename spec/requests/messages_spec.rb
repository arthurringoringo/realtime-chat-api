require 'rails_helper'

RSpec.describe "Messages", type: :request do

  before do
    @user1 = User.create!(username: "arthur")
    @user2 = User.create!(username: "juan")
    @user3 = User.create!(username: "michale")
    @chat_room_1 = ChatRoom.create!(name:"arthur's chat room", created_by: @user1)
    @chat_room_2 = ChatRoom.create!(name:"juan's chat room", created_by: @user2)
  end

  describe "POST" do
    it "return ok when create new message" do
      post_json "/messages", {room_id: @chat_room_1.id, text: "hello", sender_id: @user1.id}, {}
      expect_response(:ok, {text: "hello"})

    end

    it "return error when create invalid new message" do
      post_json "/messages", {room_id: @chat_room_1.id + 11, text: "hello", sender_id: @user1.id}, {}
      expect_response(:not_found, {error: "ChatRoom Not Found"})
    end
  end

  describe "GET" do
    before do
      post_json "/messages", {room_id: @chat_room_1.id, text: "hello", sender_id: @user1.id}, {}
      expect(:ok)
      post_json "/messages", {room_id: @chat_room_1.id, text: "any one here?", sender_id: @user1.id}, {}
      expect(:ok)
    end

    it "return ok and get all messages in a chat room" do
      get_json "/chat_room/#{@chat_room_1.id}/messages", {}
      expect_response(:ok, [{ text: "hello"}, {text: "any one here?"}])
    end

    it "return ok and empty when get all messages in a non existent chat room" do
      get_json "/chat_room/#{@chat_room_1.id+99}/messages", {}
      expect_response(:ok, [])
    end
  end
end
