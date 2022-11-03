class Comment < ApplicationRecord
  belongs_to :commenter, class_name: 'User', foreign_key: :user_id
  belongs_to :post
  has_many :notifications, as: :notifiable

  validates_presence_of :body

  after_create :create_notification_for_author_and_commenters

  private

  def create_notification_for_author_and_commenters
    notification_body = "#{commenter.email} commented post: #{post.content.truncate(37)}"
    post.author_and_commenters_ids.each do |user_to_notify_id|
      next if user_to_notify_id == commenter.id

      Notification.create(body: notification_body,
                          link: "/posts/#{post.id}",
                          recipient_id: user_to_notify_id,
                          notifiable: self)
    end
  end
end
