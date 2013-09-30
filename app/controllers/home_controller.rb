class HomeController < ApplicationController
  layout "home"
  before_filter :set_title, :set_menu
  
  def set_title
    @main_title = "Home"
  end
  
  def set_menu
    @menu = "Home"  
  end
  
  def index
    @banner = Banner.order("display_order ASC")
    @about_me = Page.where(:page_url => 'about_me').first
  end
end
