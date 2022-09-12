class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  # TODO continue profile editing, add photo
end