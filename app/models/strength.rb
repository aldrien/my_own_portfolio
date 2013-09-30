class Strength < ActiveRecord::Base
  
  require 'iconv'
  attr_accessible :title, :category, :description, :is_published, :image, :image_file_name, :image_file_size, :image_content_type
  validates_presence_of :title, :category
  
  has_attached_file :image, :styles => { 
      :thumb => "200x200>"
      # is for cropping
    },

  :url  => "/images/strengths/:id/:style/:basename.:extension",
  :path => ":rails_root/public/images/strengths/:id/:style/:basename.:extension",
  :default_url => '/images/frontend/image-noimg.png',
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

end
