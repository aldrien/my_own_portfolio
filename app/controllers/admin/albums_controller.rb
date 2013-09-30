class Admin::AlbumsController < ApplicationController
  include Admin::AdministratorModule
  before_filter :set_title, :set_menu
  before_filter :check_role, :only => [:new, :edit, :create, :update, :destroy]

  def check_role
    if session[:admin_role] != "Admin"
      @album = Album.all
      redirect_to(:action => "index", :warning => 'You are not allow to do this action!')
    end
  end
  
  def set_title
    @main_title = "Albums Management"
  end
  
  def set_menu
    @menu = "Gallery"  
  end
  
  def index
    session[:current_page_name] = 'Albums'
    @album = Album.all
    @submenu_album = "index"
  end
  
  def show
    @album = Album.all
    render :action => "index"
  end
  
  def new
    @title = "Add Album"
    @album = Album.new
    @submenu_album = "create"
    #path = Rails.application.routes.recognize_path request.url
    #render :json => path
  end
  
  def edit
    @title = "Edit Album"
    @album = Album.find(params[:id])
    @gallery_images = @album.gallery_images
    #render :json => @gallery_images
  end
  
  def create
    @album = Album.new(params[:album])
    @album.last_updated_by = session[:admin_username]
    if @album.save
      unless params[:gallery].nil?
        gallery = GalleryImage.add(params[:gallery], @album.id )
      end
      flash[:success] = 'Album was successfully created.'
      redirect_to(:url => admin_album_path(@album), :notice => 'Created Album Successfully!')
    else
      flash[:error] = 'Unable to create album.'
      render :action => "new"
    end
  end
  
  def update
    @album = Album.find(params[:id])
    @album.last_updated_by = session[:admin_username]
    if @album.update_attributes(params[:album].reject{|k,v| v.blank?})
      gallery_update = GalleryImage.update(params[:gallery], @album.id)
      flash[:success] = 'Album was successfully updated.'
      redirect_to(:url => admin_album_path, :notice => 'Updated Album  Successfully!')
    else
      flash[:error] = 'Unable to update album.'
      render :action => "edit"
    end
  end

  def strip_or_self!(str)
    str.strip! || str if str
  end
  
  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    flash[:success] = 'Album was successfully deleted.'
    redirect_to(admin_albums_url)
  end
end
