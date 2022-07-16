require "test_helper"

class FriendRequestTest < ActiveSupport::TestCase
 test "should create new FR and reject if already exists" do
   fr = FriendRequest.new(user_id: users(:one).id, friend_id: users(:two).id)
   assert fr.save

   already_fr = FriendRequest.new(user_id: users(:one).id, friend_id: users(:two).id)
   assert_not already_fr.save
 end
end
