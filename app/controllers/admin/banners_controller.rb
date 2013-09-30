class Admin::BannersController < ApplicationController

  include Admin::AdministratorModule
  before_filter :set_title, :set_menu
  before_filter :check_role, :only => [:new, :edit, :create, :update, :destroy]

  def check_role
    if session[:admin_role] != "Admin"
      @banner = Banner.all
      redirect_to(:action => "index", :warning => 'You are not allow to do this action!')
    end
  end
  
  def set_title
    @main_title = "Banner Management"
  end
  
  def set_menu
    @menu = "Banner"  
  end
  
  def index
    @banner = Banner.all
    @submenu_banner = 'index'
  end
  
  def show
    @banner = Banner.all
    render :action => "index"
  end
  
  def new
    @title = "Add Banner"
    @banner = Banner.new
    @submenu_banner = 'create'
  end
  
  def edit
    @title = "Edit Banner"
    @banner = Banner.find(params[:id])
  end
  
  def create
    @banner = Banner.new(params[:banner])
    @banner.last_updated_by = session[:admin_username]
    if @banner.save
      flash[:success] = 'Portfolio Type was successfully created.'
      redirect_to(:url => admin_banner_path(@banner), :notice => 'Created Banner Successfully!')
    else
      render :action => "new"
      flash[:error] = 'Unable to create banner.'
    end
  end
  
  def update
    @banner = Banner.find(params[:id])
    @banner.last_updated_by = session[:admin_username]
    if @banner.update_attributes(params[:banner].reject{|k,v| v.blank?})
      redirect_to(:url => admin_banner_path, :notice => 'Updated Banner Successfully!')
      flash[:success] = 'Banner was successfully updated.'
    else
      render :action => "edit"
      flash[:error] = 'Unable to update banner.'
    end
  end

  def destroy
    @banner = Banner.find(params[:id])
    @banner.destroy
    flash[:success] = 'Banner was successfully deleted.'
    redirect_to(admin_banners_url)
  end

end
