class User < ActiveRecord::Base
  require 'iconv'
  
  attr_accessible :address, :email, :hashed_password, :last_ip, :last_login_at, :phone, :role, :status, :username, :birthdate, :image, :image_file_name, :image_file_size, :image_content_type, :is_active
  attr_protected :id
  attr_accessor :password, :password_confirmation, :old_password 
  
  
  has_attached_file :image, :styles => { 
     :medium => "320x320>",
      :thumb => "200x200#"
    },
  :url  => "/images/users/:id/:style/:basename.:extension",
  :path => ":rails_root/public/images/users/:id/:style/:basename.:extension",
  :default_url => '/images/frontend/banner-noimg.png',
  :default_style => :medium
  
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
  
  
  #Validate Presence
  validates_presence_of :username, :on => :create
  validates_presence_of :first_name, :on => :create
  validates_presence_of :last_name, :on => :create
  validates_presence_of :password, :on => :create
  validates_presence_of :password_confirmation, :on => :change_password
  validates_presence_of :email, :on => :create
  validates_presence_of :role, :on => :create
  
  #Validate Length
  validates_length_of :username, :within => 3..20, :if => :username_exists?
  validates_length_of :email, :within => 3..50, :if => :email_exists?
  validates_length_of :password, :within => 3..20, :on => :create, :if => :password_required?
  validates_length_of :password_confirmation, :within => 3..20, :on => :update, :if => :password_required?
  
  #Validate Uniqueness
  validates_uniqueness_of :phone, :on => :create, :message => "was in use. Please use another phone number"#, :if => :phone_exists?
  validates_uniqueness_of :username, :on => :create, :message => "was in use. Please use another username"
  validates_uniqueness_of :email, :on => :create, :message => "was in use. Please use another email"
  
  #Confirmation
  validates_confirmation_of :password, :on => :create
  validates_confirmation_of :password, :on => :update, :if => :password_required?
  
  #Validate Format
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i#, :if => :email_exists?
  #validates_format_of :username, :with => /^[a-zA-Z0-9_]{3,20}$/, :if => :username_exists?
   
    #Method
    def self.authenticate(login, pass)
       admin = User.where(:username => login).first
       return nil if admin.nil?
       return admin if User.encrypt(pass) == admin.hashed_password
       nil
    end
     
    def self.authenticate_user(login, pass)
        admin = User.where("id = ? or email = ? or phone = ? or username = ?",login, login,login,login).first
        return nil if admin.nil?
        return admin if User.encrypt(pass) == admin.hashed_password
        nil
    end
    
    def self.verify_password(user, old_password)
      where("id = ? AND hashed_password = ?", user.id, User.encrypt(old_password)).first
    end

    def password=(pass)
       @password = pass
       self.hashed_password = User.encrypt(@password)
    end

    def username=(username)
      write_attribute(:username, username.downcase)
    end 
    
    def full_name
      full_name = ''
      unless self.first_name.nil?
        full_name = full_name + ' ' + self.first_name.capitalize
      end
      unless self.last_name.nil?
        full_name = full_name + ' ' + self.last_name.capitalize
      end
      
      return full_name
    end

     protected

     def password_required?
       !password.blank?
     end

     def username_exists?
       !username.blank?
     end
     
     def email_exists?
       !email.blank?
     end

     def self.encrypt(pass)
        Digest::MD5.hexdigest(pass)
     end

end
