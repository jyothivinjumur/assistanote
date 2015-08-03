class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :user
      t.string :action
      t.integer :email_id
      t.string :email_reference

      t.timestamps
    end
    add_index :events, :user
  end
end
