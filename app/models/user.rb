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
  has_one :profile, dependent: :destroy

  after_create { Profile.create(user: self) }

  after_create { UserMailer.welcome_email(self).deliver_now } unless Rails.env.production? 

  def friends
    User.where.not(id: id).where(id: user_and_friends_ids)
  end

  def user_and_friends_posts
    Post.where(author: user_and_friends_ids).order(created_at: :DESC)
  end

  private

  def user_and_friends_ids
    return id if accepted_friendships.empty?

    accepted_friendships.pluck(:user_id, :friend_id).flatten
  end
end
