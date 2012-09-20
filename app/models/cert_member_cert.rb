class CertMemberCert < ActiveRecord::Base
  belongs_to :member, :class_name => "ClubMember"
  belongs_to :cert_org
  belongs_to :verified_by, :class_name => "ClubMember"

  has_one   :cert_type, :through => :cert_org

  attr_accessible :cert_org, :cert_org_id, :member, :member_id, :start_date, :end_date, :comment, :verified_by,
                  :verified_by_id, :verified_date

  validates_presence_of :member
  validates_presence_of :cert_org

  validates_date_of :start_date
  validates_date_of :end_date, :after => :start_date

  def current?
    start_date <= Date.today && Date.today <= end_date
  end

  def self.for_member(member)
    self.where(:member_id => member).all
  end

  def self.current(member)
    self.all(
              :conditions => [ 
                "member_id = #{member.id} AND start_date <= :today AND :today <= end_date",
                { :today => Date.today }])
  end
  def verified?
    verified_by != nil
  end
end

gem "timezone"
gem "date_validator"