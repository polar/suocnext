class AcctLedgerAccount < ActiveRecord::Base
  belongs_to :ledger, :class_name => "AcctLedger"
  belongs_to :account, :class_name => "AcctAccount"

  attr_accessible :label, :account, :account_id, :ledger, :ledger_id, :show_if_zero, :balances_in, :position
end