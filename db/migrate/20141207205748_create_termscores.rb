class CreateTermscores < ActiveRecord::Migration
  def change
    create_table :termscores do |t|
      t.string :term
      t.decimal :score, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :termscores, :term
  end
end
