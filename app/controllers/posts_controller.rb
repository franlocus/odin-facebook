class PostsController < ApplicationController
  def index
    @posts = Post.includes(:author, :likes).all
    @post = Post.new
    @current_user_likes_posts_ids = current_user.likes.pluck(:id, :post_id)
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
