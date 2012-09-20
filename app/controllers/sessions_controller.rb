class SessionsController < BaseController
  require_from_ce("controllers/sessions_controller")

  def create
    @user_session = ClubMemberSession.new(:login => params[:login], :password => params[:password], :remember_me => params[:remember_me])

    if @user_session.save

      current_user = @user_session.record #if current_user has been called before this, it will ne nil, so we have to make to reset it

      flash[:notice] = :thanks_youre_now_logged_in.l
      redirect_back_or_default(dashboard_user_path(current_user))
    else
      flash[:notice] = :uh_oh_we_couldnt_log_you_in_with_the_username_and_password_you_entered_try_again.l
      render :action => :new
    end
  end
end

