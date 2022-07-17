class UsersController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id)
    @friend_requests = current_user.friend_requests
    @users_ids_associated_requests = FriendRequest.user_associated_requests(current_user).pluck(:user_id, :friend_id)
  end

  def show
  end
end
