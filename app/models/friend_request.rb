class FriendRequest < ApplicationRecord
  belongs_to :sended_request, class_name: 'User', foreign_key: :user_id
  belongs_to :received_request, class_name: 'User', foreign_key: :friend_id

  validates_uniqueness_of :user_id, scope: :friend_id

  def self.user_associated_requests(current_user)
    where('user_id = :current_user_id OR friend_id = :current_user_id', { current_user_id: current_user.id })
  end
end
