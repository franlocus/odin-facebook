require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not have sended requests until the user create request" do
   assert_empty users(:one).sended_requests
   users(:one).friend_requests.build(friend_id: users(:two).id).save

   assert_not_empty users(:one).sended_requests
 end

  test "should not have request if user is destroyed" do
   FriendRequest.create(user_id: users(:one).id, friend_id: users(:two).id)
   users(:one).destroy

   assert_empty users(:two).received_requests
 end
end
