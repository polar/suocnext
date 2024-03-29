class AcctReportsController < BaseController
  layout "club_operations"

  filter_access_to :all

  def index
    @income_accounts    = AcctAccount.where(:account_type_id => AcctAccountType[:Income]).order("name ASC").all
    @expense_accounts   = AcctAccount.where(:account_type_id => AcctAccountType[:Expense]).order("name ASC").all
    @asset_accounts     = AcctAccount.where(:account_type_id => AcctAccountType[:Asset]).order("name ASC").all
    @liability_accounts = AcctAccount.where(:account_type_id => AcctAccountType[:Liability]).order("name ASC").all
    @categories         = AcctCategory.all()

    @start_date = Date.parse(params[:start_date] ? params[:start_date] : fiscal_year_start_date)
    @end_date   = Date.parse(params[:end_date] ? params[:end_date] : fiscal_year_end_date)

    @income  = calculate(@income_accounts, @categories, @start_date, @end_date)
    @expense = calculate(@expense_accounts, @categories, @start_date, @end_date)

    @types             = [AcctAccountType[:Income], AcctAccountType[:Expense]]
    @category_balances = category_calculate(@types, @categories, @start_date, @end_date)

    # We calculate assets and liability up to the specific end date from the Epoch.
    # Doesn't make sense otherwise.
    @asset             = calculate(@asset_accounts, @categories, nil, @end_date)
    @liability         = calculate(@liability_accounts, @categories, nil, @end_date)

    @profit_loss = @income[:balance] + @expense[:balance]
    @net_worth   = @asset[:balance] + @liability[:balance]
  end

  private
  def category_calculate(types, categories, start_date = nil, end_date = nil)
    res = []
    for c in categories do
      bal  = 0
      bals = []
      for t in types do
        tb        = c.account_type_balance(t, start_date, end_date)
        bals[t.id]= tb
        bal       += tb
      end
      if ((bals.select { |x| x != nil && x != 0 }).length > 0)
        res << { :category => c, :type_bals => bals, :balance => bal }
      end
    end
    return res
  end

  def calculate(accounts, categories, start_date = nil, end_date = nil)
    res        = []
    grandtotal = 0
    for ac in accounts do
      if ac.reports then
        total = 0;
        accttotal  = 0
        cats       = categories.map do |c|
          subtotal  = ac.category_balance(c, start_date, end_date)
          accttotal += subtotal
          { :category => c, :balance => subtotal }
        end
        grandtotal += accttotal
        res << { :account           => ac,
                 :category_balances => cats,
                 :balance           => accttotal }
      end
    end
    return { :accounts => res, :balance => grandtotal }
  end
end