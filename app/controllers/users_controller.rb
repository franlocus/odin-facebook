class UsersController < ApplicationController
  def index
    @users = User.where.not(current_user)
  end

  def show
  end
end
