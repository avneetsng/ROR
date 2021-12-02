class StoreController < ApplicationController
  def index
    # byebug
    @products = Product.order(:title)
  end
end
