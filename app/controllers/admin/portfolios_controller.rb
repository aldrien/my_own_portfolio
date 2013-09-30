class Admin::PortfoliosController < ApplicationController

  include Admin::AdministratorModule
  before_filter :set_title, :set_menu
  before_filter :check_role, :only => [:new, :edit, :create, :update, :destroy]

  def check_role
    if session[:admin_role] != "Admin"
      @portfolio = Portfolio.all
      redirect_to(:action => "index", :warning => 'You are not allow to do this action!')
    end
  end
  
  def set_title
    @main_title = "Portfolio Management"
  end
  
  def set_menu
    @menu = "Portfolio"  
  end
  
  def index
    session[:current_page_name] = 'Portfolios'
    @portfolio = Portfolio.all
    @submenu_portfolio = "index"
  end
  
  def show
    @portfolio = Portfolio.all
    render :action => "index"
  end
  
  def new
    @title = "Add Portfolio"
    @portfolio = Portfolio.new
    @submenu_portfolio = "create"
  end
  
  def edit
    @title = "Edit Portfolio"
    @portfolio = Portfolio.find(params[:id])
    @portfolio_photos = @portfolio.portfolio_photos
    #render :json => @portfolio_photos
  end
  
  def create
    @portfolio = Portfolio.new(params[:portfolio])
    @portfolio.last_updated_by = session[:admin_username]
    if @portfolio.save
      unless params[:photo].nil?
        portfolio = PortfolioPhoto.add(params[:photo], @portfolio.id )
      end
      flash[:success] = 'Portfolio was successfully created.'
      redirect_to(:url => admin_portfolio_path(@portfolio), :notice => 'Created Portfolio Successfully!')
    else
      flash[:error] = 'Unable to create Portfolio.'
      render :action => "new"
    end
    #render :json => params[:photo][:image]
  end
  
  def update
   @portfolio = Portfolio.find(params[:id])
    @portfolio.last_updated_by = session[:admin_username]
    if @portfolio.update_attributes(params[:portfolio].reject{|k,v| v.blank?})
      photo_update = PortfolioPhoto.update(params[:photo], @portfolio.id)
      flash[:success] = 'Portfolio was successfully updated.'
      redirect_to(:url => admin_portfolio_path, :notice => 'Updated Portfolio  Successfully!')
    else
      flash[:error] = 'Unable to update Portfolio.'
      render :action => "edit"
    end
  end

  def strip_or_self!(str)
    str.strip! || str if str
  end
  
  def destroy
   @portfolio = Portfolio.find(params[:id])
    @portfolio.destroy
    flash[:success] = 'Portfolio was successfully deleted.'
    redirect_to(admin_portfolios_url)
  end

end
