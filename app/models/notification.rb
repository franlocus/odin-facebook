class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where read: false }
end
