class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :hashed_password
      t.string :role
      t.text :address
      t.string :phone
      t.boolean :is_active, :default => 1
      t.boolean :status
      t.timestamps :last_login_at
      t.string :last_ip
      t.string :first_name
      t.string :last_name
      t.string :title
      t.boolean :gender
      t.date :birthdate
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      
      t.timestamps
    end
  end
end
