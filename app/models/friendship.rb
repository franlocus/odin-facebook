class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: :friend_id

  has_many :notifications, as: :notifiable

  validates_uniqueness_of :user_id, scope: :friend_id

  after_create :create_request_notification
  after_update :create_accepted_request_notification

  scope :sent_and_received, ->(user_id) { unscope(:where).where('friend_id = :id OR user_id = :id', id: user_id) }
  scope :accepted, -> { where accepted: true }

  private

  def create_request_notification
    notification_body = "New Friend Request from #{user.email}"
    Notification.create(body: notification_body,
                        link: "/users/#{user.id}",
                        actor: user,
                        recipient: friend,
                        notifiable: self)
  end

  def create_accepted_request_notification
    notification_body = "#{friend.email} accepted your friend request! Now you are friends."
    Notification.create(body: notification_body,
                        link: "/users/#{friend.id}",
                        actor: friend,
                        recipient: user,
                        notifiable: self)
  end
end
