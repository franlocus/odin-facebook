class FriendRequestsController < ApplicationController
  def create
    @friend_request = current_user.friend_requests.build(friend_request_params)
    @friend_request[:status] = 'pending'

    if @friend_request.save
      redirect_to users_path, notice: 'Great! Now the user need to confirm your friend request :)!'
    else
      redirect_to users_path, notice: 'Something went wrong'
    end
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.destroy

    redirect_to users_path, notice: 'Request canceled successfully '
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:friend_id)
  end
end
