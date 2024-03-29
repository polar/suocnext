class ClubMembershipType < ActiveRecord::Base

  attr_accessible :name, :description

  validates_presence_of :name
  validates_uniqueness_of :name

  acts_as_enumerated
  
end
