class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.string :title
      t.text :content
      t.string :banner_file_name
      t.string :banner_content_type
      t.string :banner_file_size
      t.boolean :is_published
      t.integer :display_order
      t.string :last_updated_by
      
      t.timestamps
    end
  end
  def self.down
    drop_table :banners
  end
  
end
