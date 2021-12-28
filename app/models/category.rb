class Category < ApplicationRecord
  #ASSOCIATIONS
  has_many :sub_categories
  has_many :products

  #VALIDATIONS
  validates :name, presence: true, uniqueness: true
  validates :sub_categories, uniqueness: {}
end
