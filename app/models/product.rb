class PriceAndDiscountedPriceComparisonValidator < ActiveModel::Validator
  def validate(record)
    if record.price < record.discount_price
      record.errors.add :price, "Price must be more than discounted price"
    end
  end
end

class ImageUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ %r{\.(gif|jpg|png)\z}i
      record.errors.add attribute, "must be a URL for GIF, JPG or PNG image"
    end
  end
end

class Product < ApplicationRecord
#EXTRA CAllBACKS

#when Active Record is loaded/initalized with new
after_initialize -> { puts "After initalized is called on #{self}"}

#When Active Record is loaded from database, called before `after_initalized`
after_find -> { puts "After find is called"}

#touch updates the updated_at to the current time.
after_touch -> { puts "After Touch is called" }

before_validation -> { puts "before validation is called"}
# before_validation -> { raise StandardError.new "BEFORE validate error"}

after_validation -> { puts "after validation is called"}
# after_validation -> { raise StandardError.new "VALIDATION ERRORrR"; p "AFTER 2VALIDATION CALL"}

before_save -> { puts "Before save is called" }

# around_save -> { puts "around save is called" }

before_create -> {puts "Before create"}
# around_create -> {puts "around create"}
after_create -> {puts "after create"}
# #
before_update -> {puts "Before update"}
# around_update -> {puts "around update"}
after_update -> {puts "after update"}
# #
before_destroy -> {puts "before destroy"}
# around_destroy -> {puts "around Destroy"}
after_destroy -> { puts "After Destroy"}
#
after_save -> {puts "after save"}
# after_save -> {raise StandardError.new "nahi save karne dunga"}
#
after_commit -> {puts "after commit"}
after_rollback ->{puts "after rollback"}
# before_destroy -> { raise StandardError.new "MY ERRORRR" }


    # CALLBACKS

    after_initialize :provide_default_value_to_title, if: Proc.new { |product| product.title.nil? }
    before_validation :provide_default_discount_price, if: Proc.new { |product| product.discount_price.nil? }
    before_destroy :ensure_not_referenced_by_any_line_item

    # ASSOCIATION

    has_many :line_items, dependent: :restrict_with_error
    has_many :orders, through: :line_items
    has_many :carts, through: :line_items
    # before_destroy :ensure_not_referenced_by_any_line_item

    validates :title, :description, :image_url, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0.01 }, unless: Proc.new { |product| product.price.nil? }
    validates :title, uniqueness: true
    validates :image_url, allow_blank: true, format: {
        with: %r{\.(gif|jpg|png)\z}i, message: 'must be a URL for GIF, JPG or PNG image.'
    }
    validates :permalink, uniqueness: true, format: { with: /\A(\w+-){2,}\w+\Z/ }
    validates :description, format: { with: /\A(\s*\w+\s+){4,9}(\s*\w+\s*)\Z/ }
    validates :image_url, image_url: true
    #customValidation Type 1
    validate :price_must_be_greater_than_discount_price
    #customValidation Type 2
    validates_with PriceAndDiscountedPriceComparisonValidator
    #customValidation Type 3
    validates_each :price do |record, attribute, value|
      if value < record.discount_price
        record.errors.add attribute, "price price_must_be_greater_than_discount_price"
      end
    end

    #SCOPES
    scope :enabled_products, -> { where enabled: true }

  private

  def provide_default_value_to_title
      self.title = 'abc'
  end

  def provide_default_discount_price
      self.discount_price = price
  end

  def price_must_be_greater_than_discount_price
    if price < discount_price
      errors.add(:price, "Price must be more than the discounted price")
    end
  end

# ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
        unless line_items.empty?
            errors.add(:base, 'Line Items present')
            throw :abort
        end
    end
end
