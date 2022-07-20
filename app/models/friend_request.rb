class FriendRequest < ApplicationRecord
  belongs_to :sended_request, class_name: 'User', foreign_key: :user_id
  belongs_to :received_request, class_name: 'User', foreign_key: :friend_id

  validates_uniqueness_of :user_id, scope: :friend_id

  after_create :create_inverse
  before_destroy :destroy_inverse

  def create_inverse
    FriendRequest.create(user_id: friend_id, friend_id: user_id, status: 'pending', inverse: true)
  end

  def destroy_inverse
    FriendRequest.find_by_user_id_and_friend_id(friend_id, user_id).delete
  end
end
