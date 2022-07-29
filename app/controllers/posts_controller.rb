class PostsController < ApplicationController
  def index
    @posts = Post.includes(:author).all
    @post = Post.new
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
