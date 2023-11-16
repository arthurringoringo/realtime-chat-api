require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    @user1 = User.create!(username: "arthur")
    @user2 = User.create!(username: "juan")
  end
  describe "GET" do
    it "return all user" do
      get_json "/users", {}, {}
      expect_response(:ok, [{id: @user1.id}, {id: @user2.id}])
    end

    it "return a specific user id" do
      get_json "/users/#{@user1.id}", {},{}
      expect_response(:ok, {id: @user1.id})
    end

    it "return error when no user found" do
      get_json "/users/123123", {}, {}
      expect_response(:not_found, {error: "User Not Found"})
    end
  end

  describe "POST" do
    it "return ok when chatting as user" do
      post_json "/chat_as", {username: "arthur"},{}
      expect_response(:ok, {id: @user1.id})
      end
    it "return ok and create user when chatting as user that dont exist" do
      post_json "/chat_as", {username: "arthur123123"},{}
      expect_response(:ok, {username: "arthur123123"})
    end
  end
end
