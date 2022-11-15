class FriendshipsController < ApplicationController
  before_action :find_user_to_send_friendship, :prevent_sending_request_if_has_pending_one, only: :create
  before_action :set_friendship, only: %i[update destroy]
  before_action :prevent_cancelling_accepted_requests, only: :destroy

  def create
    @friendship = current_user.friendships.build(friendship_params)

    if @friendship.save
      flash[:notice] = 'Great, now the user must confirm your friend request'
      redirect_to user_path(@friendship.friend_id)
    else
      flash[:alert] = 'Sorry, the request could not be send'
      redirect_back fallback_location: users_path
    end
  end

  def update
    if @friendship.update(accepted: true)
      redirect_to user_path(@friendship.user_id), notice: 'Now you are friends!'
    else
      redirect_to users_path, alert: 'Sorry the request could not be accepted'
    end
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

  def find_user_to_send_friendship
    return if (@user_to_send_friendship = User.find_by_id(friendship_params[:friend_id]))

    redirect_to users_path, alert: 'Sorry, user not found!'
  end

  def prevent_sending_request_if_has_pending_one
    return unless @user_to_send_friendship.friendships.find { |f| f.friend_id == current_user.id }

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
