class AddBodyToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :body, :text
  end
end
