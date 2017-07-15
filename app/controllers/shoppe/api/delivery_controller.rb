module Shoppe
	module Api
		class DeliveriesController < BaseApiController

			def index
				@deliveries = Shoppe::DeliveryService.all

				render 'index'
			end

			def show
				@delivery = Shoppe::DeliveryService.find(params[:id])
				
				render 'show'
			end

			def update
				@delivery = Shoppe::DeliveryService.find(params[:id])

				@delivery.update(safe_params)
				@errors = JSON.parse(@delivery.errors.to_json)

				render 'show'
			end

			def create
				@delivery = Shoppe::DeliveryService.new(safe_params)
				
				@errors = JSON.parse(@delivery.errors.to_json)

				render 'show'
		    end

		    def destroy
		    	@delivery = Shoppe::DeliveryService.find(params[:id])
				
				@delivery.destroy

				render 'show'
		    end

			private

			def safe_params
				params[:delivery_service].permit(:name, :permalink, :sku, :default_image_file, :price, :cost_price, :tax_rate_id, :weight, :stock_control, :active, :default)
		    end
		end
	end
end