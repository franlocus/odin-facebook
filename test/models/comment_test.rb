require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test 'Comment must have body' do
    comment = posts.first.comments.build
    assert_changes 'comment.save' do
      # also check the errors are correct
      assert_equal ["Commenter must exist", "Body can't be blank"], comment.errors.full_messages
      comment.commenter = users.first
      comment.body = 'Yay, now I will be saved!'
    end
  end

  test '#commenter' do
    first_user_comments = users.first.comments
    assert_equal 2, first_user_comments.size
    assert_equal first_user_comments.sample.commenter, users.first
    assert_not_equal comments.first.commenter, comments.last.commenter
  end

  test '#post' do
    assert_includes posts(:one).comments, comments.first
    assert_equal 'This is post ONE', comments.first.post.content
  end

  test '#create_notification_for_author_and_commenters' do
    users.first.notifications.delete_all
    assert_changes 'users.first.notifications.unread.size' do
      assert posts.first.comments.create(commenter: users.second, body: 'nice work')
      assert posts.first.comments.create(commenter: users.third, body: 'amazing!')
    end
    assert_equal 2, users.first.notifications.unread.size
  end
end