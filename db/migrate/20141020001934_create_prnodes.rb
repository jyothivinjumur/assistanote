class CreatePrnodes < ActiveRecord::Migration
  def change
    create_table :prnodes do |t|
      t.integer :pgid
      t.string :pgnodename
      t.decimal :pgscore

      t.timestamps
    end
    add_index :prnodes, :pgid
    add_index :prnodes, :pgnodename
  end
end
