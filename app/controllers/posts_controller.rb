class PostsController < ApplicationController
  def index
    @posts = current_user.user_and_friends_posts.includes(:author, :comments).with_attached_images
    @post = Post.new
    @plucked_likes_and_posts_ids_of_user_likes = current_user.likes.pluck(:id, :post_id)
  end

  def show
    @post = Post.includes(comments: :commenter).with_attached_images.find(params[:id])
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

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_back fallback_location: root_path, notice: 'Post deleted successfully!'
  end

  private

  def post_params
    params.require(:post).permit(:content, images: [])
  end
end
