class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :page_url
      t.text :content
      t.text :short_content
      t.integer :page_id
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.string :last_updated_by
      t.date :publish_date
      t.boolean :activate
      t.integer :display_order
      
      t.timestamps
    end
  end
end
