module Shoppe
  module Api
    class ProductsController < BaseApiController

    	include Shoppe::ProductsHelper

    	def index
    		@products_paged = Shoppe::Product.root.ordered.includes(:product_categories, :variants)

        if params[:category_id].present?
        @products_paged = @products_paged
                          .where('shoppe_product_categorizations.product_category_id = ?', params[:category_id])
        elsif params[:category_permalink].present?
          cp_arr = params[:category_permalink].split('/')
          permalink = cp_arr.pop
          ancestral_permalink = cp_arr*'/'
          pc = Shoppe::ProductCategory.find_by(ancestral_permalink: ancestral_permalink, permalink: permalink)
          @products_paged = @products_paged
                          .where('shoppe_product_categorizations.product_category_id IN (?)', ([pc]+pc.flat_children).collect{|e| e.id})
        end

        if params[:featured].present?
          @products_paged = @products_paged.featured.reorder(:featured_position)
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

      def toggle
        @product = fetch_product params[:id]
        @product.active = !@product.active
        @product.save
        
        render 'show'
      end

		  def buy
  			params[:quantity] ||= 1
  			@product = fetch_product params[:id]
  			current_order.order_items.add_item(@product, params[:quantity].to_i) 
  			render 'show'
  		end

      def autocomplete
        if params[:term].present?
          @products = Shoppe::Product.where("name LIKE :query", query: "%#{params[:term]}%").limit(5)
        end
        render 'index'
      end
    end
  end
end