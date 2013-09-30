class Album < ActiveRecord::Base
  has_many :gallery_images, :dependent => :destroy
  # attr_accessible :title, :body
end
