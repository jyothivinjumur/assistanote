class Email < ActiveRecord::Base
  has_many :attachments
  has_and_belongs_to_many :evaluations
  acts_as_votable 
  self.per_page = 25
  has_one :relation

  def self.has_voted  
    @emails.votes_for_ids
  end  
end


