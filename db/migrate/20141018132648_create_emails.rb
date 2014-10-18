class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :reference_id
      t.string :path

      t.timestamps
    end
  end
end
