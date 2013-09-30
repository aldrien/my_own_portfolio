class CreateGalleryImages < ActiveRecord::Migration
  def change
    create_table :gallery_images do |t|
      
      t.integer :album_id
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.string :description
      
      t.timestamps
    end
  end
end
