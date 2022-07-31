class Friendship < ApplicationRecord
  belongs_to :sent_friendship, class_name: 'User', foreign_key: :user_id
  belongs_to :received_friendship, class_name: 'User', foreign_key: :friend_id

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates_uniqueness_of :user_id, scope: :friend_id

  after_create :create_request_notification
  after_update :create_accepted_request_notification

  private

  def create_request_notification
    notification_body = "New Friend Request from #{sent_friendship.email}"
    Notification.create(body: notification_body,
                        action: 'Friend Request',
                        actor: sent_friendship,
                        recipient: received_friendship,
                        notifiable: self)
  end

  def create_accepted_request_notification
    notification_body = "#{received_friendship.email} accepted your friend request! Now you are friends."
    Notification.create(body: notification_body,
                        action: 'Friendship',
                        actor: received_friendship,
                        recipient: sent_friendship,
                        notifiable: self)
  end
end
