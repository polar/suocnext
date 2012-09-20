#
# Club Chairmanship
#  This entity is for offices that have chairman.
#
class ClubChairmanship < ActiveRecord::Base

  has_many :current_chairs, :foreign_key => "chairmanship_id", :class_name => "ClubChair", :include => "member",
           :conditions => [ "start_date <= NOW() AND NOW() <= end_date"], :order => "end_date ASC"

  attr_accessible :name, :description

  validates_uniqueness_of :name

  def current_chairs2
    ClubChair.all(:conditions =>
      "chairmanship_id = '#{id}' AND start_date <= '#{Date.parse(Time.now.to_s)}' AND '#{Date.parse(Time.now.to_s)}' < end_date")
  end

end
