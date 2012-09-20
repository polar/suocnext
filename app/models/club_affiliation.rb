class ClubAffiliation < ActiveRecord::Base
  validates_uniqueness_of :name

  attr_accessible :name, :description, :requires_memberid

  acts_as_enumerated
end
