class AddEmailIdToRelation < ActiveRecord::Migration
  def change
    add_column :relations, :email_id, :integer
  end
end
