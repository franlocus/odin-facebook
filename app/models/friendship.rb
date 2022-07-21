class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates_uniqueness_of :user_id, scope: :friend_id

  after_create :create_inverse
  after_update :update_inverse
  after_destroy :destroy_inverse

  def create_inverse
    Friendship.create(user_id: friend.id, friend_id: user.id, inverse: true)
  end

  def update_inverse
    find_inverse.update_column(:accepted, true)
  end

  def destroy_inverse
    find_inverse.delete
  end

  private

  def find_inverse
    Friendship.find_by_user_id_and_friend_id(friend_id, user_id) 
  end
end
