class AddIndexToHistory < ActiveRecord::Migration
  def change
    add_index :histories, :node
    add_index :histories, :sent_date
  end
end
