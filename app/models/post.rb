class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  has_many :likes, dependent: :destroy

  validates_presence_of :content
end
