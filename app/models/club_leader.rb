class ClubLeader < ActiveRecord::Base
  belongs_to :member,      :class_name => "ClubMember"
  belongs_to :leadership,  :class_name => "ClubLeadership"
  belongs_to :verified_by, :class_name => "ClubMember"

  attr_accessible :member, :member_id, :leadership, :leadership_id, :start_date, :end_date, :verified_by, :verified_by_id,
                  :verified_date

  validates_presence_of :member
  validates_presence_of :leadership

  # We need to validates else it parses the date with the day first.
  validates_date_of :start_date
  validates_date_of :end_date
  validates_date_of :start_date, :before => Proc.new { Date.today }
  validates_date_of :end_date, :after => :start_date
  validates_date_of :verified_date, :allow_nil => true

  def current?
    start_date <= Date.today && Date.today <= end_date
  end

  def validate_on_create
    # apparently validates_presence_of doesn't call back before this!

    if leadership && leadership.leader?(member)
      errors.add_to_base("#{member.login} is already a leader in #{leadership.name}. Perhaps s/he is not Active/Life?")
    end
  end

  def verified?
    verified_by != nil
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

end
