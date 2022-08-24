class UsersController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id)
    @friendships = current_user.friendships
  end

  def show
    @posts = current_user.posts.includes(:author, comments: :commenter).with_attached_images.order(created_at: :DESC)
    @current_user_likes_posts_ids = current_user.likes.pluck(:id, :post_id)
  end
end
