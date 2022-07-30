class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)

    flash[:notice] = 'Liked!' if @like.save
    redirect_back fallback_location: root_path
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    redirect_back fallback_location: root_path
  end

  private

  def like_params
    params.require(:like).permit(:post_id)
  end
end
