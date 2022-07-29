class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id

  validates_presence_of :content
end
