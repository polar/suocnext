class ClubMembership < ActiveRecord::Base
  belongs_to  :member,      :class_name => "ClubMember"
  belongs_to  :acct_transaction, :class_name => "AcctTransaction"
  belongs_to  :member_type, :class_name => "ClubMembershipType"

  attr_accessible :member, :member_id, :member_type, :member_type_id, :acct_transaction, :acct_transaction_id, :year

  validates_presence_of :member
  validates_presence_of :acct_transaction
  validates_presence_of :member_type
  validates_presence_of :year

  def start_date
    if member_type == ClubMembershipType[:Spring]
      Date.parse("#{year}-01-01")
    elsif member_type == ClubMembershipType[:Year]
      Date.parse("#{year-1}-09-01")
    else
      raise "Illegal Member Type"
    end
  end

  def end_date
    Date.parse("#{year}-09-01")
  end

  def current?
    start_date <= Date.today && Date.today <= end_date
  end
end
