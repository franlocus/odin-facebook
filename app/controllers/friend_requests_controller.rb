class FriendRequestsController < ApplicationController
  def create
    @friend_request = current_user.friend_requests.build(friend_request_params)
    @friend_request[:status] = 'pending'

    if @friend_request.save
      flash[:notice] = 'Great! Now the user need to confirm your friend request :)!'
    else
      flash[:alert] = 'Something went wrong'
    end
    redirect_to users_path
  end

  def update
    @friend_request = FriendRequest.find(params[:id])

    if @friend_request.update(status: 'accepted')
      flash[:notice] = 'Now you are friends! Great :)!'
    else
      flash[:alert] = 'Something went wrong'
    end
    redirect_to users_path
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])

    if @friend_request.status == 'accepted'
      flash[:alert] = 'The request was already accepted!'
    else
      flash[:notice] = 'Request canceled successfully'
      @friend_request.destroy
    end
    redirect_to users_path
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:friend_id)
  end
end
