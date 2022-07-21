class UsersController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id)
    @friendships = current_user.friendships
  end

  def show
  end
end
