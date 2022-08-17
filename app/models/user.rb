class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friendships, ->(user) { sent_and_received(user.id) }, inverse_of: :user, dependent: :destroy
  has_many :accepted_friendships, ->(user) { sent_and_received(user.id).accepted }, class_name: 'Friendship'

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def friends
    User.where(id: friends_ids)
  end

  def user_and_friends_posts
    Post.where(author: friends_ids << id).order(created_at: :DESC)
  end

  private

  def friends_ids
    accepted_friendships.pluck(:user_id, :friend_id).flatten.reject { |user_id| user_id == id }
  end
end
