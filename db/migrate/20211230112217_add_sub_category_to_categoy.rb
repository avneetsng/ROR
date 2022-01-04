class AddSubCategoryToCategoy < ActiveRecord::Migration[6.1]
  def change
    add_reference :categories, :sub_category, foreign_key: { to_table: :categories }
    rename_column :categories, :sub_category_id, :parent_category_id
  end
end
