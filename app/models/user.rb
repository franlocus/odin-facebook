class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friendships, dependent: :destroy

  has_many :sent_friendships, class_name: 'Friendship', foreign_key: :user_id
  has_many :received_friendships, class_name: 'Friendship', foreign_key: :friend_id

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def friendships
    received_friendships.or(sent_friendships)
  end

  def friends
    friendships.where('accepted = true')
  end
end
