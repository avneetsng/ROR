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
    scope :enabled_products, -> { where(enabled: true) }

    has_many :line_items, dependent: :restrict_with_error
    has_many :orders, through: :line_items
    has_many :carts, through: :line_items
    # has_one :category
    # has_one :sub_category, through: :category
    belongs_to :category
    belongs_to :sub_category, optional: true
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

    def price_must_be_greater_than_discount_price
      if price < discount_price
        errors.add(:price, "Price must be more than the discounted price")
      end
    end

  private
# ensure that there are no line items referencing this product
    def ensure_not_referenced_by_any_line_item
        unless line_items.empty?
            errors.add(:base, 'Line Items present')
            throw :abort
        end
    end
end
