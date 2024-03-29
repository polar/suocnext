#
# The controller for the ClubChairs.
#
class ClubChairsController < BaseController
  layout "club_operations"

  filter_access_to :all
  filter_access_to :new_chair, :require => :create
  filter_access_to :delete_chair, :require => :delete
  filter_access_to :my_index, :require => :read

  def index
    @club_chairs = ClubChair.order("end_date DESC").paginate(:page => params[:page], :per_page => 6)
  end

  def show
    @club_chair = ClubChair.find(params[:id])
    @club_chairship  = @club_chair.chairship
  end

  def edit
    @club_chair = ClubChair.find(params[:id])
    @club_chairship  = @club_chair.chairship
  end

  def update
    @club_chair = ClubChair.find(params[:id])

    if @club_chair.update_attributes(params[:club_chair])
      flash[:notice] = "The Chairship held by #{@club_chair.member.login} was successfully updated."
      redirect_to(@club_chair)
    else
      render :action => "edit"
    end
  end

  def new_chair
    @club_chair = ClubChair.new(params[:club_chair])

    if @club_chair.member != current_user
      flash[:error] = "Error in transmission"
      @club_chair.errors.messages << (
          "Somehow you tried to update another members chairship. Try again");
      @current_chairs = current_user.current_chairs
      @past_chairs = current_user.past_chairs
      @club_chair.member = current_user
      render :action => :my_index, :id => "me"
    elsif @club_chair.update_attributes(params[:club_chair])
      flash[:notice] = "The Chairship held by #{@club_chair.member.login} was added ."
      redirect_to :action => :my_index, :id => "me"
    else
      @current_chairs = current_user.current_chairs
      @past_chairs = current_user.past_chairs
      render :action => :my_index, :id => "me"
    end
  end

  def my_index
    @club_chair = ClubChair.new(:member => current_user)
    @current_chairs = current_user.current_chairs
    @past_chairs = current_user.past_chairs
  end

  def delete_chair
    chair = ClubChair.find(params[:id])
    if (chair)
      chair.destroy
    end
    redirect_to :action => "my_index", :id => "me"
  end

  def destroy
    @club_chair = ClubChair.find(params[:id])
    @club_chair.destroy

    redirect_to(club_chairs_path)
  end
end
