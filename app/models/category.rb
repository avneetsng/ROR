class Category < ApplicationRecord
  #ASSOCIATIONS

  #Creating a self join on Category
  has_many :sub_categories, class_name: "Category", foreign_key: "parent_category_id",
            dependent: :destroy
  belongs_to :parent_category, class_name: "Category", optional: true

  #Other Associations
  has_many :products, dependent: :restrict_with_error
  has_many :sub_category_products, through: :sub_categories, source: :products

  #Callbacks
  before_destroy :check_sub_product_count, :check_product_count, prepend: true
  #VALIDATIONS
  validates :name, presence: true
  validates :name, uniqueness: {scope: :parent_category_id},
    if: -> { name }

  private

 # Also could have used total_products Instead of this ;_;
  def check_sub_product_count
    all_sub_products_empty = self.sub_categories.all? do |sub_category|
      sub_category.products.count.nil?
    end

    unless all_sub_products_empty
      self.errors.add :base, "sub_category have linked products"
      throw :abort
    end
  end

  def check_product_count
    if self.products.count > 0
      self.errors.add :base, "category has linked products"
      throw :abort
    end
  end



end
