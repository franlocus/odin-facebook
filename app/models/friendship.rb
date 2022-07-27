class Friendship < ApplicationRecord
  belongs_to :sent_friendship, class_name: 'User', foreign_key: :user_id
  belongs_to :received_friendship, class_name: 'User', foreign_key: :friend_id

  validates_uniqueness_of :user_id, scope: :friend_id
end
