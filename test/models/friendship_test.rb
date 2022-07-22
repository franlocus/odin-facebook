require "test_helper"

class FriendshipTest < ActiveSupport::TestCase
  test "create friendship if doesnt exit and reject if already exist" do
    user_id = friendships(:one).user_id
    friend_id = friendships(:one).friend_id
    Friendship.delete_all

    # create friendship
    friendship = Friendship.new(user_id: user_id, friend_id: friend_id)
    assert friendship.save

    # check inverse creation
    assert_not friendship.inverse?
    friendship_inverse = Friendship.find_by_user_id_and_friend_id(friend_id, user_id) 
    assert friendship_inverse.inverse?

    # check failing validation of uniqueness 
    already_friendship = Friendship.new(user_id: user_id, friend_id: friend_id)

    assert_not already_friendship.save
  end

  test "should destroy friendship is user is destroyed" do
    users(:one).destroy

    assert_empty users(:two).friends
  end
end
