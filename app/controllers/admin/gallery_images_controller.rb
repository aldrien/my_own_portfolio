class Admin::GalleryImagesController < ApplicationController
  include Admin::AdministratorModule
  before_filter :set_title, :set_menu
  before_filter :check_role, :only => [:new, :edit, :create, :update, :destroy]

  def check_role
    if session[:admin_role] != "Admin"
      @gallery_image = GalleryImage.all
      redirect_to(:action => "index", :warning => 'You are not allow to do this action!')
    end
  end
  
  def set_title
    @main_title = "Gallery Images Management"
  end
  
  def set_menu
    @menu = "Gallery"  
  end
  
  def index
    session[:current_page_name] = 'Gallery Images'
    @gallery_image = GalleryImage.all
    @submenu_gallery_image = "index"
  end
  
  def show
    @gallery_image = GalleryImage.all
    render :action => "index"
  end
  
  def new
    @title = "Add Gallery Images"
    @gallery_image = GalleryImage.new
    @submenu_gallery_image = "create"
    #path = Rails.application.routes.recognize_path request.url
    #render :json => path
  end
  
  def edit
    @title = "Edit Album"
    @gallery_image = GalleryImage.find(params[:id])
  end
  
  def create
    @gallery_image = GalleryImage.new(params[:gallery_image])
    @gallery_image.last_updated_by = session[:admin_username]
    if @gallery_image.save
      redirect_to(:url => admin_gallery_image_path(@gallery_image), :notice => 'Created Gallery Images Successfully!')
    else
      render :action => "new"
    end
  end
  
  def update
    @gallery_image = GalleryImage.find(params[:id])
    @gallery_image.last_updated_by = session[:admin_username]
    if @gallery_image.update_attributes(params[:gallery_image].reject{|k,v| v.blank?})
      redirect_to(:url => admin_gallery_image_path, :notice => 'Updated Gallery Images  Successfully!')
    else
      render :action => "edit"
    end
  end

  def destroy
    @gallery_image = GalleryImage.find(params[:id])
    @gallery_image.destroy
    
    redirect_to(admin_gallery_images_url)
  end

end
