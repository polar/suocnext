class ClubTripRegistration < ActiveRecord::Base
  belongs_to :leader, :class_name => "ClubMember"
  belongs_to :leadership, :class_name => "ClubLeadership"
  has_and_belongs_to_many   :club_members, :uniq => true

  attr_accessible :leader, :leader_id, :leadership, :leadership_id, :email, :phone, :trip_name, :departure_date,
                  :return_date, :mode_of_transport, :location, :overnight_location, :overnight_phone,
                  :notes, :attendees, :submit_data, :submit_date

  validates_presence_of :leader
  validates_presence_of :leadership
  validates_presence_of :trip_name
  validates_date_of :departure_date
  validates_date_of :return_date
  validates_presence_of :email
  validates_presence_of :location

  def days
      ret = ((return_date - departure_date)).floor + 1
      if ret < 0 || ret > 10 # Its a mistake, so say it's 1
          ret = 1
      end
      ret
  end

  def people_days
      days * club_members.count
  end

  def submitted?
    !submit_date.nil?
  end

  private

  def abs(x)
      x < 0  ? -x : x
  end
end
