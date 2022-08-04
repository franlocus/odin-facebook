require "test_helper"

class UserTest < ActiveSupport::TestCase
  test '#friendships' do
    assert_equal 1, users(:first).friendships.size
  end

  test '#friends are unfriended when user is destroyed' do
    assert_changes 'users(:second).friends.size' do
      users(:first).destroy
    end
  end

  test '#notifications' do
    assert_equal 1, users(:first).notifications.size
    assert_equal users(:second), notifications(:one).recipient

    assert_equal 1, users(:second).notifications.size
    assert_equal users(:first), notifications(:two).recipient
  end

  test '#posts' do
    assert_equal 1, users(:first).posts.size

    assert_changes 'Post.count' do
      users(:first).destroy
    end
  end

  test '#likes' do
    assert_equal 2, users(:first).likes.size

    assert_changes 'Like.count' do
      users(:first).destroy
    end
  end
end
