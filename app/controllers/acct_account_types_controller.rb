class AcctAccountTypesController < BaseController
  layout "club_operations"
  
  filter_access_to :all

  ACCOUNT_TYPES_PER_PAGE = 10
  ENTRIES_PER_PAGE  = 10


  def index
    @account_types = AcctAccountType.order(:name).paginate(
        :page => params[:page], :per_page => ACCOUNT_TYPES_PER_PAGE)

  end

  def show
    @account_type = AcctAccountType.find(params[:id])
  end

end
