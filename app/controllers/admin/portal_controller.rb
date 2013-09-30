class Admin::PortalController < ApplicationController
  include Admin::AdministratorModule
  include ActionView::Helpers::DateHelper
  before_filter :set_title, :set_menu
  before_filter :login_required, :except => [:login, :doLogin]
  layout :resolve_layout
  
  def set_title
     @title = "Home"
  end
  
  def set_menu
    @menu = "Dashboard"
  end 
   
   
  def login
      if(cookies[:remember_me_id] and cookies[:remember_me_code] and User.exists?(cookies[:remember_me_id]) and Digest::SHA1.hexdigest(User.where(:id => cookies[:remember_me_id]).first.email)[4,18] == cookies[:remember_me_code])
        admin = User.find(cookies[:remember_me_id])  
        session[:admin_user] = admin.id
        session[:admin_username] = admin.username
        session[:admin_role] = admin.role
        session[:admin_avatar] = admin.image.url(:thumb)
        session[:first_name] = admin.first_name
        session[:last_name] = admin.last_name
        
        redirect_to_stored
      end
  end
  
  def doLogin
    if @user = User.authenticate(params[:Username],params[:Password])
        if @user.is_active == false
            respond_to do |format|
            format.html { 
                flash[:error] = 'Sorry, your account is inactive.'
                render :login
              }
            end
        else
              @user.update_attributes(:last_login_at => Time.current, :last_ip => request.env['REMOTE_ADDR'])
              @user.save
              session[:admin_user] = @user.id
              session[:admin_username] = @user.username
              session[:admin_role] = @user.role
              session[:admin_avatar] = @user.image.url(:thumb)
              session[:first_name] = @user.first_name
              session[:last_name] = @user.last_name
                if params[:remember_me]
                  userId = @user.id.to_s
                  cookies[:remember_me_id] = {:value => userId, :expires => 30.days.from_now}
                  userCode = Digest::SHA1.hexdigest(@user.email)[4,18]
                  cookies[:remember_me_code] = {:value => userCode, :expires => 30.days.from_now}
                end
              redirect_to_stored
         end
    else
        respond_to do |format|
          format.html { 
            flash[:error] = 'Invalid username or password!'
            render :login
          }
        end
    end
  end
   
  def logout
    @user = User.find(session[:admin_user])
    @user.update_attributes(:last_login_at => Time.now)
    #log_activity("User", session[:admin_user], "sign_out")
    session = nil
    reset_session
    if cookies[:page] then cookies.delete :page end
    if cookies[:remember_me_id] then cookies.delete :remember_me_id end
    if cookies[:remember_me_code] then cookies.delete :remember_me_code end
    
    redirect_to :action => :login
  end
  
  def index
    @title_action = "Home"
    if cookies[:page] then cookies.delete :page end
    session[:current_page_name] = "Dashboard"
    
    @recent_users = User.where("last_login_at IS NOT NULL").order("last_login_at DESC").limit(10)    
    #@activities = ActivityLog.order("created_at DESC").limit(100)
    
    @active_banner = Banner.where(:is_published => true)
    @portfolios = Portfolio.where(:is_published => true)
    
    @strength = Strength.count
    @strength_category = Strength.count('category', :distinct => true)
    #@test = Room.select("hotel_floor_id").group("hotel_floor_id")
  end
  
  
  
  private

    def resolve_layout
      case action_name
      when "login", "logout", "doLogin"
        "login"
      when "index"
        "administrator"
      else
        "administrator"
      end
    end
    
    def strip_or_self!(str)
      str.strip! || str if str
    end


end
