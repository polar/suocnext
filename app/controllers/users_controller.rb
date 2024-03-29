#
# ClubMembers Controller
#   Engines Plugin to Community Engine's UsersController
#
class UsersController < BaseController
  require_from_ce("controllers/users_controller")

  # Brings the user model upto ClubMember
  before_filter :becomes_club_member

  # Sets the type of the newly created user and some
  # defaults
  after_filter :create_club_member, :only => [ :create ]

  #
  # Sets the role for an activated club member.
  #
  after_filter :activate_club_member, :only => [ :activate ]

  # Need to include UsersHelper to get the
  # rendering functions
  # for Ajax calls
  include UsersHelper
  include BaseHelper

  # This function gets called as a before filter to
  # transform the current user, if any, to its extension.
  def becomes_club_member
    # For some reason @current_user == :false
    # (ie. not false or not nil) if it isn't assigned!
    # We check to see if it's still a User.
    if @current_user && @current_user.class == User
      @current_user = @current_user.becomes(ClubMember)
    end
  end

  def create_club_member
    @user.type = "ClubMember"

    # Keep the users profile from immediately going public
    @user.profile_public = false;
    @user.save
  end

  #
  # Set the role for a new member to be member.
  def activate_club_member
    # if the activation was not successful, current user
    # will not be assigned.
    if self.current_user
      self.current_user.add_role(:member)
    end
  end

  before_filter :before_dashboard, :only => :dashboard

  def before_dashboard
    @messages = ClubLoginMessage.order("date DESC").limit(4).all
  end

  ##
  ## Override
  ##
  def create
    #@user       = User.new(params[:user])
    params[:user][:club_start_date] =
        normalize_date_string(params[:user][:club_start_date])
    params[:user][:club_grad_year]  =
        normalize_grad_year_string(params[:user][:club_grad_year])
    @user                           = ClubMember.new(params[:user])
    @user.role                      = Role[:member]

    if (!configatron.require_captcha_on_signup || verify_recaptcha(@user)) && @user.save
      create_friendship_with_inviter(@user, params)
      flash[:notice] = :email_signup_thanks.l_with_args(:email => @user.email)
      if Rails.env == "development"
        @user.activate
        @user.add_role(:member)
        @user.save
      end
      redirect_to signup_completed_user_path(@user)
    else
      render :action => 'new'
    end
  end

  ##
  ## Override
  ##
  def index
    @users, @search, @metro_areas, @states = User.search_conditions_with_metros_and_states(params)

    # Add order conditions to cond.
    case params[:sort]
    when "name-asc"
      order = 'login ASC'
    when "recent-desc"
      order = 'activated_at DESC'
    when "activity-desc"
      order = "activities_count DESC"
    end

    @users = @users.active.recent.includes(:tags).order(order).page(params[:page]).per(20)

    @metro_areas, @states = User.find_country_and_state_from_search_params(params)

    @tags = User.tag_counts :limit => 10

    # for radio button display
    @sort = params[:sort]

    setup_metro_areas_for_cloud
  end

  def update_club_member_info
    member = ClubMember.find(params[:id])
    if permitted_to? :write, member
      params[:club_member][:club_start_date] =
          normalize_date_string(params[:club_member][:club_start_date])
      params[:club_member][:club_grad_year] =
          normalize_grad_year_string(params[:club_member][:club_grad_year])
      if member.update_attributes(params[:club_member])
        can_edit_info = current_user.admin? || current_user == member
        render_club_member_info(member, can_edit_info)
      else
        render_edit_club_member_info(member)
      end
    else
      flash[:error] = "You do not have permission to edit"
      render_club_member_info(member, false)
    end
  end

  def edit_club_member_info
    member = ClubMember.find(params[:id])
    can_edit_info = permitted_to? :write, member
    if can_edit_info
      render_edit_club_member_info(member)
    else
      render_club_member_info(member, can_edit_info)
    end
  end

  def show_club_member_info
    member = ClubMember.find(params[:id])
    can_edit_info = permitted_to? :write, member
    render_club_member_info(member, can_edit_info)
  end

  def update_form_cert_orgs
    cert_orgs = CertOrg.find_by_cert_type_id(params[:cert_type])
    render :partial => "cert_member_certs/form_cert_orgs", :locals => {
      :cert_orgs => cert_orgs }
  end

  def verify_cert
    cert = CertMemberCert.find(params[:cert_member_cert_id])
    cert.verified_by = current_user
    cert.verified_date = Date.today
    if cert.save
      redirect_to :action => "show", :id => params[:id]
    else
      flash[:error] = "Cannot verify certification"
      redirect_to :action => "show", :id => params[:id]
    end
  end

  def delete_cert
    cert = CertMemberCert.find(params[:cert_member_cert_id])
    cert.destroy
    redirect_to :action => "show", :id => params[:id]
  end

  def verify_leader
    leader = ClubLeader.find(params[:club_leader_id])
    leader.verified_by = current_user
    leader.verified_date = Date.today
    if leader.save
      redirect_to :action => "show", :id => params[:id]
    else
      flash[:error] = "Cannot verify leadership"
      redirect_to :action => "show", :id => params[:id]
    end
  end

  def delete_leader
    leader = ClubLeader.find(params[:club_leader_id])
    leader.destroy
    redirect_to :action => "show", :id => params[:id]
  end
  
  #
  # Override
  #  This should come with an Email. It's in the new version
  #  of CommunityEngine, but something still isnt' right
  #  The signup_completed view states a link with "id=#{@user.to_param}"
  # which is defined to be the login_slug. This doesn't make sense anyway.
  
  def resend_activation
    return unless request.post?       

    if params[:email]
      @user = User.find_by_email(params[:email])
    else
      @user = User.find(params[:id])
    end
    
    if @user && !@user.active?
      flash[:notice] = :activation_email_resent_message.l
      UserNotifier.deliver_signup_notification(@user)    
      redirect_to login_path and return
    else
      flash[:notice] = :activation_email_not_sent_message.l
    end
  end

  protected

  #
  # This returns a ClubOfficer or nil
  #
  def new_officer(member, params)
    if params['club_office']
      if permitted_to? :write, member
        if !params['office_id'].empty?
          params['member'] = member
          x = ClubOfficer.new(params)
          if !x.save
            member.errors.messages << x.errors.to_s
            return false
          end
        end
      end
    end
    return true
  end

  #
  # This returns a ClubChair or nil
  #
  def new_chair(member, params)
    if params['club_chair']
      params = params['club_chair']
      if permitted_to? :write, member
        if !params['activity_id'].empty?
          params['member'] = member
          x = ClubChair.new(params)
          if !x.save
            member.errors.messages << x.errors.to_s
            return false
          end
        end
      end
    end
    return true
  end

  #
  # This returns a ClubLeader or nil
  #
  def new_leader(member, params)
    if params['club_leader']
      params = params['club_leader']
      if permitted_to? :write, member
        if !params['leadership_id'].empty?
          params['member'] = member
          x = ClubLeader.new(params)
          if !x.save
            member.errors.messages << x.errors.to_s
            return false
          end
        end
      end
    end
    return true
  end

  protected

  def normalize_date_string(stdate)
    if stdate
      if stdate =~ /^\s*[0-9][0-9][0-9][0-9]\s*$/
        stdate = "09-01-#{stdate}"
      else
        stdate
      end
    else
      stdate = "01-01-#{Date.today.year}"
    end
  end
  
  def normalize_grad_year_string(stdate)
    if stdate
      if stdate =~ /^\s*[0-9][0-9][0-9][0-9]\s*$/
        stdate = "05-10-#{stdate}"
      else
        stdate
      end
    end
  end
end

