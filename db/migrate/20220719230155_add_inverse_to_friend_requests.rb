class AddInverseToFriendRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :friend_requests, :inverse, :boolean
  end
end
