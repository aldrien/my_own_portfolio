class Admin::StrengthsController < ApplicationController
  include Admin::AdministratorModule
  before_filter :set_title, :set_menu
  before_filter :check_role, :only => [:new, :edit, :create, :update, :destroy, :activate_user, :deactivate_user]

  def check_role
    if session[:admin_role] != "Admin"
      @strength = Strength.all
      redirect_to(:action => "index", :warning => 'You are not allow to do this action!')
    end
  end
  
  def set_title
    @main_title = "Strength Management"
  end
  
  def set_menu
    @menu = "Strength"  
  end
  
  def index
    @strength = Strength.all
    @submenu_strength = "index"
  end
  
  def show
    @strength = Strength.all
    render :action => "index"
  end
  
  def new
    @title = "Add Strength"
    @strength = Strength.new
    @submenu_strength = "create"
  end
  
  def edit
    @title = "Edit Strength"
    @strength = Strength.find(params[:id])
  end
  
  def create
    @strength = Strength.new(params[:strength])
    @strength.last_updated_by = session[:admin_username]
    if @strength.save
      redirect_to(:url => admin_strength_path(@strength), :notice => 'Created Strength Successfully!')
      flash[:success] = 'Strength was successfully created.'
    else
      render :action => "new"
      flash[:error] = 'Unable to create strength.'
    end
  end
  
  def update
    @strength = Strength.find(params[:id])
    @strength.last_updated_by = session[:admin_username]
    if @strength.update_attributes(params[:strength].reject{|k,v| v.blank?})
      redirect_to(:url => admin_strength_path, :notice => 'Updated Strength Successfully!')
      flash[:success] = 'Strength was successfully updated.'
    else
      render :action => "edit"
      flash[:error] = 'Unable to update strength.'
    end
  end

  def destroy
    @strength = Strength.find(params[:id])
    @strength.destroy
    flash[:success] = 'Strength was successfully deleted.'
    redirect_to(admin_strengths_url)
  end

end
