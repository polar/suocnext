class AcctCategoriesController < BaseController
  layout "club_operations"

  PER_PAGE = "10"
  ENTRIES_PER_PAGE  = 10

  filter_access_to :all

  include Viewable
  uses_tiny_mce(:options => configatron.default_mce_options.merge({:editor_selector => "rich_text_editor"}),
    :only => [:new, :create, :update, :edit])

  def index
    @page = params[:page]
    @per_page = params[:per_page] ? params[:per_page] : PER_PAGE
    @categories = AcctCategory.order(:name).paginate(:page => @page, :per_page => @per_page)
    @start_date = Chronic.parse(params[:start_date] ? params[:start_date] : fiscal_year_start_date)
    @end_date = Chronic.parse(params[:end_date] ? params[:end_date] : fiscal_year_end_date)
    @categories_map = @categories.map do |c|
      r = {}
      r["category"] = c
      r["name"] = c.name
      r["description"] = c.description
      r["income_balance"] = c.account_type_balance(AcctAccountType[:Income], @start_date, @end_date)
      r["expense_balance"] = c.account_type_balance(AcctAccountType[:Expense], @start_date, @end_date)
      r["balance"] = r["income_balance"] + r["expense_balance"]
      r
    end
  end

  def show
    @category = AcctCategory.find(params[:id])
  end

  def new
    @category = AcctCategory.new
    @submit = "Create"
  end

  def edit
    @category = AcctCategory.find(params[:id])
    @submit = "Update"
  end

  def create
    AcctCategory.enumeration_model_updates_permitted = true
    @category = AcctCategory.new(params[:acct_category])

    if @category.save
      flash[:notice] = "The account category #{@category.name} was successfully created."
      redirect_to @category
    else
      render :action => "new"
    end
  end

  def update
    AcctCategory.enumeration_model_updates_permitted = true

    @category = AcctCategory.find(params[:id])

    if @category.update_attributes(params[:acct_category])
      flash[:notice] = "The account category #{@category.name} was successfully updated."
      redirect_to @account_type
    else
      render :action => "edit"
    end
  end

  def destroy
    AcctCategory.enumeration_model_updates_permitted = true
    @category = AcctCategory.find(params[:id])
    error = false
    if !AcctEntry.where(:category_id => @category).all.empty?
      @category.errors.messages << "Account Category #{@category.name} has associated transactions."
      error = true
    end
    if !AcctAction.where(:category_id => @category).all.empty?
      @category.errors.messages << "Account Category #{@category.name} has associated actions."
      error = true
    end
    if !error && @category.destroy
      flash[:notice] = "Account Category #{@category.name} has been deleted."
      redirect_to acct_categories_url
    else
      flash[:error] = "Account Category #{@category.name} cannot be deleted."
    end
  end
end
