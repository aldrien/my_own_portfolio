# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130915093835) do

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "is_published"
    t.string   "last_updated_by"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "banners", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.string   "banner_file_size"
    t.boolean  "is_published"
    t.integer  "display_order"
    t.string   "last_updated_by"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "enquiries", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "phone"
    t.text     "message"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "gallery_images", :force => true do |t|
    t.integer  "album_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "page_url"
    t.text     "content"
    t.text     "short_content"
    t.integer  "page_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "last_updated_by",    :limit => 30
    t.date     "publish_date"
    t.boolean  "activate"
    t.integer  "display_order"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "portfolio_photos", :force => true do |t|
    t.integer  "portfolio_id"
    t.string   "image_file_name"
    t.string   "image_file_size"
    t.string   "image_content_type"
    t.string   "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "portfolio_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "portfolios", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "is_published"
    t.string   "last_updated_by"
    t.string   "image_file_name"
    t.string   "image_file_size"
    t.string   "image_content_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "display_order"
    t.string   "portfolio_type"
  end

  create_table "strengths", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.string   "last_updated_by"
    t.string   "is_published"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "users", :force => true do |t|
    t.string    "username"
    t.string    "email"
    t.string    "hashed_password"
    t.string    "role"
    t.text      "address"
    t.string    "phone"
    t.boolean   "is_active",          :default => true
    t.boolean   "status"
    t.timestamp "last_login_at"
    t.datetime  "created_at",                           :null => false
    t.datetime  "updated_at",                           :null => false
    t.string    "last_ip"
    t.string    "first_name"
    t.string    "last_name"
    t.string    "title"
    t.boolean   "gender"
    t.date      "birthdate"
    t.string    "image_file_name"
    t.string    "image_content_type"
    t.integer   "image_file_size"
  end

end
