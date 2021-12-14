class ChangeDefaultValueOfEnabledField < ActiveRecord::Migration[6.1]
  def change
    change_column_default :products, :enabled, from: nil, to: false 
  end
end
