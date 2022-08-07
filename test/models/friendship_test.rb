require "test_helper"

class FriendshipTest < ActiveSupport::TestCase
  test "create friendship if doesnt exit and reject if already exist" do
    # create friendship
    friendship = Friendship.new(user_id: users.first.id, friend_id: users.third.id)
    assert friendship.save

    # user first and third should not be friends until the friendship is accepted
    assert_not_includes users.first.friends, users.third
    assert_not friendship.accepted

    assert_changes 'users.first.friends' do
      friendship.update_column(:accepted, true)
    end

    # check failing validation of uniqueness 
    assert_raise ActiveRecord::RecordInvalid do
      Friendship.create!(user_id: users.first.id, friend_id: users.third.id)
    end
  end

  test "should destroy friendship is one of the users is destroyed" do
    assert_changes 'users.second.friends' do
      users(:first).destroy
    end
  end
end
