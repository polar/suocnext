class AcctAction < ActiveRecord::Base
  
  belongs_to :action_type, :class_name => "AcctActionType"

  belongs_to :account,  :class_name => "AcctAccount"
  belongs_to :category, :class_name => "AcctCategory"

  attr_accessible :name, :description, :account, :account_id, :category, :category_id, :action_type, :action_type_id
end
