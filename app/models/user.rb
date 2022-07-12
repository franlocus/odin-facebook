class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sended_requests, class_name: 'FriendRequest', dependent: :destroy
  has_many :received_requests, class_name: 'FriendRequest', foreign_key: :friend_id, dependent: :destroy

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
end
