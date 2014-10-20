class Help < ActiveRecord::Migration
  def change
  	change_column :prnodes, :pgscore, :decimal, :precision => 10, :scale => 10		
  end
end
