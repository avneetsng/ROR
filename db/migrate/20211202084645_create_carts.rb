class CreateCarts < ActiveRecord::Migration[6.1]
  def change
    drop_table :carts
    create_table :carts do |t|

      t.timestamps
    end
  end
end
