class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sent_friendships, class_name: 'Friendship', foreign_key: :user_id, dependent: :destroy
  has_many :received_friendships, class_name: 'Friendship', foreign_key: :friend_id, dependent: :destroy

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def friendships
    received_friendships.or(sent_friendships)
  end

  def accepted_friendships
    friendships.where(accepted: true)
  end

  def friends
    friends_ids = accepted_friendships.pluck(:user_id, :friend_id).flatten.reject { |user_id| user_id == id }
    User.where.not(id: id).where(id: friends_ids)
  end
end
