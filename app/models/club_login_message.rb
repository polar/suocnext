class ClubLoginMessage < ActiveRecord::Base
  belongs_to :author, :class_name => "ClubMember"

  attr_accessible :date, :message, :author, :author_id

  validates_date_of :date
  validates_presence_of :author
end
