require "test_helper"

class LikeTest < ActiveSupport::TestCase
  test 'validates uniqueness user id in scope post id' do
    assert users.second.likes.create(post: posts.first)

    assert_raise ActiveRecord::RecordInvalid do
      users.second.likes.create!(post: posts.first) 
    end
  end

  test "liking a post creates a notification to post author " do
    assert_changes 'posts.first.author.notifications.size' do
      users.second.likes.create(post: posts.first)
    end
    assert_equal users.second, posts.first.author.notifications.last.actor
    assert_equal 'second@email.com likes your post: This is post ONE', posts.first.author.notifications.last.body
  end
end
