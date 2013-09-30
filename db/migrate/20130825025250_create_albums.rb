class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.text :description
      t.boolean :is_published
      t.string :last_updated_by
      
      t.timestamps
    end
  end
end
