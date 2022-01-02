class RemoveSubCategoryRefrenceInProducts < ActiveRecord::Migration[6.1]
  def change
    remove_reference :products, :sub_category, foreign_key: true
  end
end
