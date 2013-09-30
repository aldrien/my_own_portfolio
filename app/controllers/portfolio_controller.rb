class PortfolioController < ApplicationController
  layout "other"
  before_filter :set_title, :set_menu
  
  def set_title
    @main_title = "Portfolio"
  end
  
  def set_menu
    @menu = "Portfolio"  
  end
  
  def index
    @portfolio = Portfolio.order("display_order ASC")
    @web = Strength.where(:category => 'Web Programming')
    @mobile = Strength.where(:category => 'Mobile Programming')
    @tools = Strength.where(:category => 'Development Tools')
    @scripting = Strength.where(:category => 'Scripting Languages')
    @server_os = Strength.where(:category => 'Servers and OS')
    @databases = Strength.where(:category => 'Databases')
    @others = Strength.where(:category => 'Others')
  end

  def show
    @portfolio = Portfolio.find(params[:id])
    @portfolio_list = Portfolio.where("id <> ?", params[:id]).order("display_order ASC")
  end

  
end
