module Shoppe
  module Api
    class ProductCategoriesController < BaseApiController

    	include Shoppe::ProductsHelper

    	def index
    		@product_categories = Shoppe::ProductCategory.without_parent.ordered
  			render 'index'
    	end

    end
  end
end