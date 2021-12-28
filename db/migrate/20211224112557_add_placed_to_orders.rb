class AddPlacedToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :placed, :datetime
  end
end
