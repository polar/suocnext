class ClubRole < ActiveRecord::Base
  attr_accessible :title, :club_member, :club_member_id

  validates_presence_of :title

  belongs_to :club_member

  #
  # The Declarative Authorization
  # plugin needs the user attribute.
  #
  belongs_to :user, :class_name => "ClubMember",
                    :foreign_key => :club_member_id
end

