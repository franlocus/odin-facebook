require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "Post must have content" do
    post = users.first.posts.build
    assert_not post.save
    assert_equal ["Content can't be blank"], post.errors.full_messages
  end

  test '#likes' do
    assert_equal posts(:one), likes(:one).post
  end
end
