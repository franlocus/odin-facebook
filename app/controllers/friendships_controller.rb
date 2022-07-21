class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:update, :destroy]
  before_action :prevent_cancelling_accepted_requests, only: :destroy

  def create
    @friendship = current_user.friendships.build(friendship_params)

    if @friendship.save
      flash[:notice] = 'Great, now the user must confirm your friend request'
    else
      flash[:alert] = 'Something went wrong'
    end
    redirect_to users_path
  end

  def update
    if @friendship.update(accepted: true)
      flash[:notice] = 'Now you are friends!'
    else
      flash[:alert] = 'Something went wrong'
    end
    redirect_to users_path
  end

  def destroy
    if @friendship.destroy
      flash[:notice] = (params[:commit] =~ /Delete/ ? 'Friend deleted successfully' : 'Request cancelled successfully')
    else
      flash[:alert] = 'Something went wrong'
    end
    redirect_to users_path
  end

  private

  def friendship_params
    params.require(:friendship).permit(:friend_id)
  end

  def set_friendship
    return if (@friendship = Friendship.find_by_id(params[:id]))

    redirect_to users_path, alert: 'Sorry, friend not found! Try again'
  end

  def prevent_cancelling_accepted_requests
    return unless params[:commit] =~ /Cancel/ && @friendship.accepted?

    flash[:alert] = 'The request was already accepted'
    redirect_to users_path
  end
end
