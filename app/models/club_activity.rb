#
# Club Activity
#   This is the activity division in the club.
#
class ClubActivity < ActiveRecord::Base
  has_many :leaderships, :class_name => "ClubLeadership", :foreign_key => "activity_id"
  has_many :chairs, :class_name => "ClubChair", :foreign_key => "activity_id", :include => "member"

  has_many :current_chairs, :foreign_key => "activity_id", :class_name => "ClubChair", :include => "member",
           :conditions => [ "start_date <= NOW() AND NOW() <= end_date"], :order => "end_date ASC"

  attr_accessible :name, :description, :tagline, :position

  acts_as_list

  validates_presence_of :name

  validates_uniqueness_of :name

  def past_chairs(page, per_page)
    ClubChair.paginate(:all,
      :page => page,
      :per_page => per_page,
      :order => 'end_date DESC',
      :conditions =>
        "activity_id = '#{id}' AND end_date < '#{Date.parse(Time.now.to_s)}'")
  end

  def current_chairs2
    ClubChair.all(:conditions =>
      "activity_id = '#{id}' AND start_date <= '#{Date.parse(Time.now.to_s)}' AND '#{Date.parse(Time.now.to_s)}' <= end_date")
  end
end
