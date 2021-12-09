class AddColumnsToCart < ActiveRecord::Migration[6.1]
  def change
    change_table :carts do |t|
      t.integer :line_items_count, null: false, default: 0  
    end
  end
end
