module Shoppe
  module Api
    class ProductsController < BaseApiController

    	include Shoppe::ProductsHelper

    	def index
    		@products_paged = Shoppe::Product.root.includes(:product_categories, :variants, :translations)

        if params[:category_id].present?
        @products_paged = @products_paged
                          .where('shoppe_product_categorizations.product_category_id = ?', params[:category_id])
        elsif params[:category_permalink].present?
        pc = Shoppe::ProductCategory.find_by(permalink: params[:category_permalink].split('/').last)
        @products_paged = @products_paged
                          .where('shoppe_product_categorizations.product_category_id IN (?)', ([pc]+pc.flat_children).collect{|e| e.id})
        end

        if params[:featured].present?
          @products_paged = @products_paged.featured.order(:featured_position)
        else
          @products_paged = @products_paged.ordered
        end

        if params[:limit].present?
          @products_paged = @products_paged.limit(params[:limit].to_i)
        end

        @products = @products_paged

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
  			render 'show'
  		end
    end
  end
end