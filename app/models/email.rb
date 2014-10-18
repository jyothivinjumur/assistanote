class Email < ActiveRecord::Base
  has_many :attachments
  has_and_belongs_to_many :evaluations
end