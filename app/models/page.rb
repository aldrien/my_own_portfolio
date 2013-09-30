class Page < ActiveRecord::Base
  require 'iconv'
  validates_presence_of :title, :page_url
  
  has_attached_file :image, :styles => { 
      :thumb => "200x200>",
      :large => "400x400>"
      # is for cropping
    },

  :url  => "/images/pages/:id/:style/:basename.:extension",
  :path => ":rails_root/public/images/pages/:id/:style/:basename.:extension",
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
end
