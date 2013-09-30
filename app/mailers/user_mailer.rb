class UserMailer < ActionMailer::Base
  default :from => "noreply@defapp.com"
  
  require 'mail'

  def enquiry_email(enquiry)
      @enquiry = enquiry
      mail(:to => "aldrienhate@yahoo.com",
           :subject => "Mr. Hate Website - Web Enquiry")
  end
  
end