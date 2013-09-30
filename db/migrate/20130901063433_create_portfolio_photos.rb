class CreatePortfolioPhotos < ActiveRecord::Migration
  def change
    create_table :portfolio_photos do |t|
      t.integer :portfolio_id
      t.string :image_file_name
      t.string :image_file_size
      t.string :image_content_type
      t.string :description
      
      t.timestamps
    end
  end
end
