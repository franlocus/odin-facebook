class RemoveActorIdFromNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :actor_id, :integer
  end
end
