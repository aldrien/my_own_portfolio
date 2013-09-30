class Admin::UsersController < ApplicationController
  include Admin::AdministratorModule
  before_filter :set_title, :set_menu
  before_filter :check_role, :only => [:new, :edit, :create, :update, :destroy, :activate_user, :deactivate_user]

  def check_role
    if session[:admin_role] != "Admin"
      @user = User.all
      redirect_to(:action => "index", :warning => 'You are not allow to do this action!')
    end
  end
  
  def set_title
    @main_title = "Users Management"
  end
  
  def set_menu
    @menu = "User"  
  end
  
  def index
    @user = User.all
    @submenu_membership = "index"
  end
  
  
  def show
    @user = User.all
    render :action => "index"
  end
  
  def new
    @title = "Add User"
    @user = User.new
    @submenu_membership = "create"
    #path = Rails.application.routes.recognize_path request.url
    #render :json => path
  end
  
  def edit
    @title = "Edit User"
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to(:url => admin_user_path(@user), :notice => 'Created User Successfully!')
      flash[:success] = 'User Account was successfully created.'
    else
      render :action => "new"
      flash[:error] = 'Unable to create User Account.'
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user].reject{|k,v| v.blank?})
      flash[:success] = 'User Account was successfully updated.'
      redirect_to(:url => admin_user_path, :notice => 'Updated User Successfully!')
    else
      render :action => "edit"
      flash[:error] = 'Unable to update User Account.'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = 'User Account was successfully deleted.'
    redirect_to(admin_users_url)
  end

  def deactivate_user
    @user = User.find(params[:id])
    @user.is_active = false
    if @user.save
      flash[:success] = 'User Account was successfully deactivated.'
      redirect_to(admin_users_url)
    else
      flash[:error] = 'Unable to deacticate User Account.'
      redirect_to(admin_users_url)
      #render :json => @user.errors.full_messages
    end
  end
  
  def activate_user
    @user = User.find(params[:id])
    @user.is_active = true
    if @user.save
      redirect_to(admin_users_url)
      flash[:success] = 'User Account was successfully activated.'
    else
      flash[:error] = 'Unable to activate User Account'
      redirect_to(admin_users_url)
      #render :json => @user.errors.full_messages  
    end
    
  end
end
