class Admin::PagesController < ApplicationController
  include Admin::AdministratorModule
  before_filter :set_title, :set_menu
  before_filter :check_role, :only => [:new, :edit, :create, :update, :destroy, :activate_user, :deactivate_user]

  def check_role
    if session[:admin_role] != "Admin"
      @page = Page.all
      redirect_to(:action => "index", :warning => 'You are not allow to do this action!')
    end
  end
  
  def set_title
    @main_title = "Pages Management"
  end
  
  def set_menu
    @menu = "Page"  
  end
  
  def index
    session[:current_page_name] = 'Pages'
    @page = Page.all
    @submenu_page = "index"
    #render :json => session[:admin_username]
  end
  
  def show
    @page = Page.all
    render :action => "index"
  end
  
  def new
    @title = "Add Page"
    @page = Page.new
    @submenu_page = "create"
  end
  
  def edit
    @title = "Edit Page"
    @page = Page.find(params[:id])
  end
  
  def create
    @page = Page.new(params[:page])
    @page.last_updated_by = session[:admin_username]
    if @page.save
      redirect_to(:url => admin_page_path(@page), :notice => 'Created Page Successfully!')
      flash[:success] = 'Page was successfully created.'
    else
      render :action => "new"
      flash[:error] = 'Unable to create page.'
    end
  end
  
  def update
    @page = Page.find(params[:id])
    @page.last_updated_by = session[:admin_username]
    if @page.update_attributes(params[:page].reject{|k,v| v.blank?})
      redirect_to(:url => admin_page_path, :notice => 'Updated Page Successfully!')
      flash[:success] = 'Page was successfully updated.'
    else
      render :action => "edit"
      flash[:error] = 'Unable to update page.'
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @user.destroy
    flash[:success] = 'Page was successfully deleted.'
    redirect_to(admin_pages_url)
  end
end
