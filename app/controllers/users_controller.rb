class UsersController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id)
    @sended_and_received_requests = current_user.sended_and_received_requests
  end

  def show
  end
end
