class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :message
      t.boolean :read
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
