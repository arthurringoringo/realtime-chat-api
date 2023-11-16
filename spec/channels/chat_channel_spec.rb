require 'rails_helper'


RSpec.describe ChatChannel, type: :channel do

  before do
    @user1 = User.create!(username: "arthur")
    @user2 = User.create!(username: "juan")
    @user3 = User.create!(username: "michale")
    @chat_room_1 = ChatRoom.create!(name:"arthur's chat room", created_by: @user1)
    @chat_room_2 = ChatRoom.create!(name:"juan's chat room", created_by: @user2)
  end

  it "connects to websocket" do
    stub_connection(user: @user1)
    assert_equal "arthur", connection.user.username
  end

  it "subscribe to websocket" do
    stub_connection(user:@user1)
    subscribe user_id: @user1.id
    assert subscription.confirmed?
    assert_has_stream_for @user1
  end

  it "doesn't subscribe to websocket when no user_id given" do
    stub_connection(user:@user1)
    expect{ subscribe id: @user1.id }.to raise_error(ActionController::ParameterMissing)
    assert subscription.rejected?
  end

  it "broadcast message to subscriptions" do
    stub_connection(user:@user1)
    subscribe user_id: @user1.id
    assert subscription.confirmed?
    assert_has_stream_for @user1

    post_json "/messages", {room_id: @chat_room_1.id, text: "hello", sender_id: @user1.id}, {}
    expect_response(:ok, {text: "hello"})
    assert_broadcasts(@user1, 1)
  end

  it "broadcast message to subscriptions from other user" do
    stub_connection(user:@user1)
    subscribe user_id: @user1.id
    assert subscription.confirmed?
    assert_has_stream_for @user1
    post_json "/chat_rooms/join/#{@chat_room_1.id}", {user_id: @user3.id},{}
    expect_response(:ok,{id: @chat_room_1.id})

    post_json "/messages", {room_id: @chat_room_1.id, text: "hello am here", sender_id: @user3.id}, {}
    expect_response(:ok, {text: "hello am here"})
    assert_broadcasts(@user1, 1)
    assert_broadcasts(@user3, 1)
  end
end
