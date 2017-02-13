module Shoppe
  module Api
    class ProductsController < BaseApiController

    	include Shoppe::ProductsHelper

      	def index
      		@products = Shoppe::Product.root.ordered.includes(:product_categories, :variants)
			render 'index'
      	end

      	def show
      		@product = fetch_product params[:id]
      		render 'show'
		end

		def buy
			params[:quantity] ||= 1
			@product = fetch_product params[:id]
			current_order.order_items.add_item(@product, params[:quantity].to_i) 
			puts current_order.order_items
			render 'show'
		end
    end

  end
end