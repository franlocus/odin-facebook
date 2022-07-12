class FriendRequest < ApplicationRecord
  belongs_to :sended_request, class_name: 'User', foreign_key: :user_id
  belongs_to :received_request, class_name: 'User', foreign_key: :friend_id
end
