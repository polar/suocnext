class PaypalReunionPayment < ActiveRecord::Base
  belongs_to :member,       :class_name => "ClubMember"

  attr_accessible :member, :member_id, :ipn_data

  def params
    if ! @params
      @params = eval ipn_data
    end
    @params
  end
  
end
