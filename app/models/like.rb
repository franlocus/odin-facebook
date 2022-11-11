class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  has_one :notification, as: :notifiable

  validates_uniqueness_of :user_id, scope: :post_id

  after_create :create_like_notification, unless: proc { user == post.author }

  private

  def create_like_notification
    notification_body = "#{user.email} likes your post: #{post.content.truncate(37)}"
    Notification.create(body: notification_body,
                        link: "/posts/#{post.id}",
                        recipient: post.author,
                        notifiable: self)
  end
end
