class Evaluation < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :emails
end
