class ContactController < ApplicationController
  layout "contact"
  before_filter :set_title, :set_menu
  
  def set_title
    @main_title = "Contact"
  end
  
  def set_menu
    @menu = "Contact"  
  end
  
  def index
    
  end
  
  def submit_enquiry
    @enquiry = Enquiry.new(params[:enquiry])
      if @enquiry.save
        UserMailer.enquiry_email(@enquiry).deliver
        session[:enquiry] = "Sent"
        #flash[:success] = 'Enquiry was successfully sent!'
        render :action => "index"
      else
        #flash[:error] = 'Sorry, unable to send enquiry!'
        redirect_to(:action => "index", :warning => 'Sorry, unable to send your enquiry!')
      end
  end
  
  def change_session
    session[:enquiry] = "None"
    render :action => "index"
  end
  
end
