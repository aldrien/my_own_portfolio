class CreateEnquiries < ActiveRecord::Migration
  def change
    create_table :enquiries do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phone
      t.text :message
      t.integer :status
      
      t.timestamps
    end
  end
end
