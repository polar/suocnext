class CertType < ActiveRecord::Base
  acts_as_list

  attr_accessible :name, :description, :position
  validates_presence_of :name
end
