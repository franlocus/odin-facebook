class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :images

  validates :content, presence: true, unless: proc { |post| post.images.attached? }

  def author_and_commenters_ids
    commenters_ids = comments.distinct.pluck(:user_id)
    (commenters_ids << author.id).uniq
  end
end
