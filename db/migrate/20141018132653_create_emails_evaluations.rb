class CreateEmailsEvaluations < ActiveRecord::Migration
  def change
    create_table :emails_evaluations do |t|
      t.belongs_to :email, index: true
      t.belongs_to :evaluation, index: true
    end
  end
end
