class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :action
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.boolean :read, default: false
      t.references :notifiable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
