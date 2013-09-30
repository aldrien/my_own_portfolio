class Enquiry < ActiveRecord::Base
  attr_accessible :firstname, :lastname, :email, :phone, :message
  
  validates_presence_of :firstname
  validates_presence_of :lastname
  validates_presence_of :email
  validates_presence_of :message
  validates_format_of :email,
                      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                      :on => :create
end
