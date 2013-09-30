class AboutController < ApplicationController
  layout 'other'
  before_filter :set_title, :set_menu
  
  def set_title
    @main_title = "About Me"
  end
  
  def set_menu
    @menu = "About Me"  
  end
  
  def index
    @about = Page.where(:page_url => 'about_me').first
  end
end
