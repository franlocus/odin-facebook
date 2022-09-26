class LikesController < ApplicationController
  before_action :set_like, only: [:destroy]

  def create
    @like = current_user.likes.build(like_params)

    if @like.save
      flash[:notice] = 'Liked!'
    else
      flash[:alert] = 'You already like it!'
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    @like.destroy

    redirect_back fallback_location: root_path
  end

  private

  def like_params
    params.require(:like).permit(:post_id)
  end

  def set_like
    return if (@like = Like.find_by_id(params[:id]))

    redirect_back fallback_location: root_path, alert: 'Sorry, like not found!'
  end
end
