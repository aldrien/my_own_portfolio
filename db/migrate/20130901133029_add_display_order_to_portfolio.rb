class AddDisplayOrderToPortfolio < ActiveRecord::Migration
  def self.up
    add_column :portfolios, :display_order, :integer
  end
  
  def self.down
    remove_column :portfolios, :display_order
  end
end
