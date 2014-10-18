class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :reference_id
      t.string :path
      t.references :email, index: true

      t.timestamps
    end
  end
end
