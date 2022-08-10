class PostsController < ApplicationController
  def index
    @posts = Post.includes(:author, :comments).order(created_at: :DESC)
    @post = Post.new
    @current_user_likes_posts_ids = current_user.likes.pluck(:id, :post_id)
  end

  def show
    @post = Post.includes(comments: :commenter).find(params[:id])
    @current_user_post_like = Like.where('user_id = ? AND post_id = ?', current_user.id, params[:id]).take
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post created successfully!'
    else
      flash[:post_errors] = @post.errors.full_messages
      redirect_back fallback_location: root_path
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
