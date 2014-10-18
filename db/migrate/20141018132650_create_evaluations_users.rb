class CreateEvaluationsUsers < ActiveRecord::Migration
  def change
    create_table :evaluations_users do |t|
      t.belongs_to :evaluation, index: true
      t.belongs_to :user, index: true
    end
  end
end
