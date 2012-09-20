class CertOrg < ActiveRecord::Base
  acts_as_list
  belongs_to :cert_type

  attr_accessible :name, :description, :position, :cert_type, :cert_type_id

  validates_presence_of :name
  validates_presence_of :cert_type
  validates_uniqueness_of :name, :scope => :cert_type_id, :message => "Organization already has a the selected Certification Type"
end

