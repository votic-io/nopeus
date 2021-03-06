module Shoppe
  module Api
    class ProductsController < BaseApiController

    	include Shoppe::ProductsHelper

    	def index
    		@products_paged = Shoppe::Product.root.ordered.includes(:product_categories, :variants)

        if params[:active].present?
          @products_paged = @products_paged.active
        end

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
        if params[:order].present?
          @products_paged = @products_paged.reorder(params[:order])
        end

        if params[:limit].present?
          @products_paged = @products_paged.limit(params[:limit].to_i)
        end

        @products = @products_paged

		  	render 'index'
    	end

      def new
        @product = Shoppe::Product.new
        render 'show'
      end      

    	def show
    		@product = fetch_product params[:id]
    		render 'show'
    	end

      def import_images
        @product = fetch_product params[:id]
        @product.import_images
        
        render 'show'
      end

      def create
        puts "CREATE"
        @debug = {source: 'create', params: params}
        @product = Shoppe::Product.new(safe_params)
        @product.save

        @errors = JSON.parse(@product.errors.to_json)
        render 'show'
      end

      def update
        puts "UPDATE"
        @debug = {source: 'update', params: params}
        if params.present?
          @debug[:enter] = 'u'
          @product = fetch_product params[:id]
          @product.update(safe_params)
          @product.touch
        else
          @debug[:enter] = 'c'
          @product = Shoppe::Product.new(safe_params)
          @product.save          
        end

        @errors = JSON.parse(@product.errors.to_json)
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

      private

      def safe_params
        file_params = [:file, :parent_id, :role, :parent_type, file: []]
        params[:product].permit(:name, :sku, :permalink, :description, :short_description, :weight, :price, :cost_price, :tax_rate_id, :stock_control, :active, :featured, :in_the_box, attachments: [default_image: file_params, data_sheet: file_params, extra: file_params], product_attributes_array: [:key, :value, :searchable, :public], product_category_ids: [])
        #a[:price] = a[:price].to_f
        #a[:cost_price] = a[:cost_price].to_f
        #a
      end
    end
  end
end