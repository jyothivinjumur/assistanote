class AddCategorytoEmails < ActiveRecord::Migration
  def change
  	add_column :emails, :category, :string
    add_index :emails, :category
  end
end
