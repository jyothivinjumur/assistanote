class Email < ActiveRecord::Base
  has_many :attachments
end
