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
  validate :sub_category_has_one_level_nesting

  private

  #validation methods
  def sub_category_has_one_level_nesting
    if parent_category_id
      parent_category = Category.find_by_id(parent_category_id)
      if parent_category && parent_category.parent_category_id
        self.errors.add :category, "Only one level nesting is allowed"
      end
    end
  end

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

public

  def update_total_products(product)
    p "Update total products is called "
    if parent_category_id.present?
      p "updating the value - TRUE"
      parent_category = Category.find(parent_category_id)
      p "parent_category's name is #{parent_category.name} and product count is #{parent_category.total_products}"
      # parent_category.increment(:total_products).save #-> This won't work because we have set this coulumn as couter_cache
      # To increment the parent_catergory use the increment_counter method.
      Category.increment_counter(:total_products, parent_category_id, touch: true)
      Category.decrement_counter(:total_products, product.category_id_before_last_save, touch: true)
    end
  end

end
