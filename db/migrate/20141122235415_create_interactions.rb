class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.integer :sender, index: true
      t.integer :receiver, index: true
      t.text :comm

      t.timestamps
    end
  end
end
