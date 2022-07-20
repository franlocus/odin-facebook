class AddInverseToFriendships < ActiveRecord::Migration[7.0]
  def change
    add_column :friendships, :inverse, :boolean, default: false
  end
end
