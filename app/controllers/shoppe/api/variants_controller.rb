module Shoppe
	module Api
		class VariantsController < BaseApiController

			def show
				@product = Shoppe::Product.find(params[:product_id])
				@variant = @product.variants.find(params[:id])

				render 'show'
			end

			def update
				@product = Shoppe::Product.find(params[:product_id])
				@variant = @product.variants.find(params[:id])

				@variant.update(safe_params)
				@errors = JSON.parse(@variant.errors.to_json)

				render 'show'
			end

			private

			def safe_params
				params[:product].permit(:name, :permalink, :sku, :default_image_file, :price, :cost_price, :tax_rate_id, :weight, :stock_control, :active, :default)
		    end
		end
	end
end