class ChangeNotificationsActionToLink < ActiveRecord::Migration[7.0]
  def change
    rename_column :notifications, :action, :link
  end
end
