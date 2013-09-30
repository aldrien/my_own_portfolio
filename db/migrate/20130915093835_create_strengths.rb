class CreateStrengths < ActiveRecord::Migration
  def self.up
    create_table :strengths do |t|
      t.string :title
      t.string :description
      t.string :category
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.string :last_updated_by
      t.string :is_published
      
      t.timestamps
    end
  end
  def self.down
    drop_table :strengths
  end
  
end
