class AddCountToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :total_products, :integer, default: 0
  end
end
