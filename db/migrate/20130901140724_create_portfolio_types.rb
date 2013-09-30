class CreatePortfolioTypes < ActiveRecord::Migration
  def change
    create_table :portfolio_types do |t|
      t.string :name
      t.string :description
      
      t.timestamps
    end
  end
end
