class UsersController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id)
    @friendships = current_user.friendships
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:author, comments: :commenter).with_attached_images.order(created_at: :DESC)
    @plucked_likes_and_posts_ids_of_user_likes = current_user.likes.pluck(:id, :post_id)
  end
end
