class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :country
      t.string :phone
      t.integer :age
      t.string :contact_email
      t.string :hobbies
      t.string :interests
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
