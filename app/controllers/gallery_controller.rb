class GalleryController < ApplicationController
  layout "other"
  before_filter :set_title, :set_menu
  
  def set_title
    @main_title = "Gallery"
  end
  
  def set_menu
    @menu = "Gallery"  
  end
  
  def index
    @album = Album.all
    for a in @album
      #@photos = a.gallery_images.image_file_name
    end
   #render :json => @album
  end
  
end
