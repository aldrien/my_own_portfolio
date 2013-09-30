class Admin::PortfolioTypesController < ApplicationController
  include Admin::AdministratorModule
  before_filter :set_title, :set_menu
  before_filter :check_role, :only => [:new, :edit, :create, :update, :destroy]

  def check_role
    if session[:admin_role] != "Admin"
      @type = PortfolioType.all
      redirect_to(:action => "index", :warning => 'You are not allow to do this action!')
    end
  end
  
  def set_title
    @main_title = "Portfolio Type Management"
  end
  
  def set_menu
    @menu = "Settings"  
  end
  
  def index
    session[:current_page_name] = 'Portfolio Types'
    @type = PortfolioType.all
    @submenu_portfolio_type = 'Portfolio Type'
  end
  
  def show
    @type = PortfolioType.all
    render :action => "index"
  end
  
  def new
    @title = "Add Portfolio Type"
    @type = PortfolioType.new
    @submenu_portfolio_type = 'Portfolio Type'
  end
  
  def edit
    @title = "Edit Portfolio Type"
    @type = PortfolioType.find(params[:id])
  end
  
  def create
    @type = PortfolioType.new(params[:type])
    if @type.save
      flash[:success] = 'Portfolio Type was successfully created.'
      redirect_to(:url => admin_portfolio_type_path(@type), :notice => 'Created Portfolio Type Successfully!')
    else
      render :action => "new"
      flash[:error] = 'Unable to create portfolio type.'
    end
  end
  
  def update
    @type = PortfolioType.find(params[:id])
    if @type.update_attributes(params[:type].reject{|k,v| v.blank?})
      redirect_to(:url => admin_portfolio_type_path, :notice => 'Updated Portfolio Type  Successfully!')
      flash[:success] = 'Portfolio Type was successfully updated.'
    else
      render :action => "edit"
      flash[:error] = 'Unable to update portfolio type.'
    end
  end

  def destroy
    @type = PortfolioType.find(params[:id])
    @type.destroy
    flash[:success] = 'Portfolio Type was successfully deleted.'
    redirect_to(admin_portfolio_types_url)
  end
end
