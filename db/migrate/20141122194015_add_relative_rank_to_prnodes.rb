class AddRelativeRankToPrnodes < ActiveRecord::Migration
  def change
    add_column :prnodes, :relative_rank, :decimal, :precision => 10, :scale => 2
  end
end
