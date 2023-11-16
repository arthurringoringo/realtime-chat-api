class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render_json(@users)
  end

  # GET /users/1
  def show
    render_json(@user)
  end

  # POST /chat_as
  def as_user
    @user = User.find_or_create_by!(username: request_body[:username])

    if @user
      render_json(@user)
    else
      raise ActiveRecord::RecordNotFound, "User not found"
    end
  end
  #
  # # PATCH/PUT /users/1
  # def update
  #   if @user.update(user_params)
  #     render json: @user
  #   else
  #     render json: @user.errors, status: :unprocessable_entity
  #   end
  # end
  #
  # # DELETE /users/1
  # def destroy
  #   @user.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
end
