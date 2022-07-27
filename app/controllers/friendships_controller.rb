class FriendshipsController < ApplicationController
  before_action :prevent_sending_request_if_have_pending_one, only: :create
  before_action :set_friendship, only: [:update, :destroy]
  before_action :prevent_cancelling_accepted_requests, only: :destroy

  def create
    @friendship = current_user.sent_friendships.build(friendship_params)

    if @friendship.save
      flash[:notice] = 'Great, now the user must confirm your friend request'
    else
      flash[:alert] = 'Sorry, the request could not be send'
    end
    redirect_to users_path
  end

  def update
    if @friendship.update(accepted: true)
      flash[:notice] = 'Now you are friends!'
    else
      flash[:alert] = 'Sorry the request could not be accepted'
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

  def prevent_sending_request_if_have_pending_one
    return unless current_user.received_friendships.find { |f| f.user_id == friendship_params[:friend_id] }

    redirect_to users_path, alert: 'You already have a pending request!'
  end

  def set_friendship
    return if (@friendship = Friendship.find_by_id(params[:id]))

    redirect_to users_path, alert: 'Sorry, friendship not found! Try again'
  end

  def prevent_cancelling_accepted_requests
    return unless params[:commit] =~ /Cancel/ && @friendship.accepted?

    flash[:alert] = 'The request was already accepted'
    redirect_to users_path
  end
end
