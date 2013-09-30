class GalleryImage < ActiveRecord::Base
  belongs_to :album
  require 'iconv'
  
  attr_accessible :image, :image_file_name, :image_file_size, :image_content_type, :description, :album_id
  
  has_attached_file :image, :styles => { 
      :thumb => "200x200>",
      :large => "400x400>"
      # is for cropping
    },

  :url  => "/images/gallery_images/:id/:style/:basename.:extension",
  :path => ":rails_root/public/images/gallery_images/:id/:style/:basename.:extension",
  :default_url => '/images/frontend/banner-noimg.png',
  :default_style => :thumb
  
  before_post_process :transliterate_file_name
  
  def transliterate_file_name
    extension = File.extname(image.original_filename).gsub(/^\.+/, '')
    filename = image.original_filename.gsub(/\.#{extension}$/, '')
    self.image.instance_write(:file_name, "#{transliterate(filename)}.#{transliterate(extension)}")
  end
  
  def transliterate(str)
    s = Iconv.iconv('ascii//ignore//translit', 'utf-8', str).to_s
    s.downcase!
    s.gsub!(/'/, '')
    s.gsub!(/[^A-Za-z0-9]+/, ' ')
    s.strip!
    s.gsub!(/\ +/, '-')
    return s
  end
  
  # validates_attachment_size :image, :less_than => 5.megabytes
  # validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/jpg', 'image/gif']
  
  
  class << self
    
        def add(gallery, album_id)
          ids = []
            unless gallery.nil?
              ids = gallery[:photo].keys
                ids.each do |id|
                    if gallery[:photo][id.to_sym] != ''
                      related = GalleryImage.new
                      unless gallery[:description].nil?
                        related.description = strip_or_self!(gallery[:description][id.to_sym])
                      end
                      related.image = gallery[:photo][id.to_sym]
                      related.album_id = album_id
                      related.save
                    end
                end
            end
        end
    
        def update(param, album_id)
          begin
              old_ids = []
              @related_img = GalleryImage.where(:album_id => album_id)
              @related_img.each do |related|
                old_ids << related.id
              end
              related = []
              current_ids = []
              current_ids = param[:description].keys
              res = []
              current_ids.each do |id|
                  if old_ids.include?(id.to_i)
                    @related = GalleryImage.where(:id => id.to_i).first
                        unless @related.nil?
                            if param[:clone_photo][id.to_sym] != ''
                                if param[:photo].present?
                                    unless param[:photo][id.to_sym].nil?
                                      @related.update_attributes(:image => param[:photo][id.to_sym])
                                    end
                                end
                                
                                unless param[:description][id.to_sym].nil? || 
                                  @related.update_attributes(:description => param[:description][id.to_sym])
                                end
                                
                                #res = param[:clone_photo][id.to_sym]#@related
                                
                                
                            end
                        end
                        
                  else
                        if param[:photo][id.to_sym] != ''               
                            @related = GalleryImage.new
                            @related.image = param[:photo][id.to_sym]
                              if param[:description].present?
                                @related.description = strip_or_self!(param[:description][id.to_sym])
                              end
                            @related.album_id = album_id
                            @related.save
                        end
                  end
              end
           #return {:val => res}
              unless current_ids.empty?
                current_ids = current_ids.map { |val| val.to_i }
                removed_param = old_ids - current_ids
                removed_param.each do |r|
                  removed_related = GalleryImage.where(:id => r).first
                  unless removed_related.nil?
                    removed_related.destroy  
                  end
                end
              end
          rescue
            
          end  
        end
    
    
        def strip_or_self!(str)
          str.strip! || str if str
        end
    
  end
  
  
end
