class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string :title
      t.text :description
      t.boolean :is_published
      t.string :last_updated_by
      t.string :image_file_name
      t.string :image_file_size
      t.string :image_content_type
      
      t.timestamps
    end
  end
end
