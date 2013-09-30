class AddPortfolioTypeToPortfolio < ActiveRecord::Migration
  def self.up
    add_column :portfolios, :portfolio_type, :string
  end
  
  def self.down
    remove_column :portfolios, :portfolio_type
  end
end
