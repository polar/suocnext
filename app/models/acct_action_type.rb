
class AcctActionType < ActiveRecord::Base
  validates_uniqueness_of :name
  acts_as_enumerated

  attr_accessible :name, :description
end
