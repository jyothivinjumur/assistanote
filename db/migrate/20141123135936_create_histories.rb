class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :node
      t.date :sent_date
      t.decimal :score, :precision => 10, :scale => 2

      t.timestamps
    end
  end
end
