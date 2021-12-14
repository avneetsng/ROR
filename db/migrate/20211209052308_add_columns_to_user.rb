class AddColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.string :email, :string
    end
  end
end
