class ClubChair < ActiveRecord::Base
  belongs_to :member,       :class_name => "ClubMember"
  belongs_to :activity,     :class_name => "ClubActivity"

  attr_accessible :member, :member_id, :activity, :activity_id, :start_date, :end_date

  validates_presence_of :member
  validates_presence_of :activity

  # We need to validates else it parses the date with the day first.
  validates_date_of :start_date
  validates_date_of :end_date
  validates_date_of :start_date, :before => Proc.new { Date.today }
  validates_date_of :end_date, :after => :start_date

  def current?
    start_date <= Date.today && Date.today <= end_date
  end
end
