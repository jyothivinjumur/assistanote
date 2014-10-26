class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.string :email, index: true
      t.integer :node, index: true
      t.string :recipient

      t.timestamps
    end
  end
end
