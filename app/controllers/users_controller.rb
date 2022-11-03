class UsersController < ApplicationController
  before_action :set_user, only: :show

  def index
    @pagy, @users = pagy(User.where.not(id: current_user.id), items: 9)
    @friendships = current_user.friendships
  end

  def show
    @posts = @user.posts.includes(:author, comments: :commenter).with_attached_images.order(created_at: :DESC)
    @plucked_likes_and_posts_ids_of_user_likes = current_user.likes.pluck(:id, :post_id)
    @friendship = current_user.friendships.where('user_id = :show_user_id OR friend_id = :show_user_id', show_user_id: @user.id ).take
  end

  private

  def set_user
    return if (@user = User.find_by_id(params[:id]))

    redirect_to users_path, alert: 'Sorry, user not found! Try again'
  end
end
