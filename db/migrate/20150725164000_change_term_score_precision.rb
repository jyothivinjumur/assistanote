class ChangeTermScorePrecision < ActiveRecord::Migration
  def change
    change_column :termscores, :score, :decimal, :precision => 10, :scale => 5
  end
end
