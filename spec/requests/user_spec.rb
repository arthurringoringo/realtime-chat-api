require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET" do
    it "return all user" do
      @user1 = User.create!(username: "Arthur")
      @user2 = User.create!(username: "ArthurBoi")

      get_json "/users", {}, {}
      expect_response(:ok, [{id: @user1.id}, {id: @user2.id}])
    end
  end
end
