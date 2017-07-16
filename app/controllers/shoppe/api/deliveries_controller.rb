module Shoppe
	module Api
		class DeliveriesController < BaseApiController

			before_filter { params[:id] && @delivery = Shoppe::DeliveryService.where(active: [true,false]).find(params[:id]) }

			def index
				@deliveries = Shoppe::DeliveryService.all

				render 'index'
			end

			def show
				render 'show'
			end

			def update
				@price = @delivery.delivery_service_prices.first
				if @price.nil?
					@price = Shoppe::DeliveryServicePrice.new(price_safe_params)
					@price.save
					@delivery.delivery_service_prices = [@price]
					@delivery.save
				else
					@price.update(price_safe_params)
					@delivery.save
				end
				@delivery.update(safe_params)
				@errors = JSON.parse(@delivery.errors.to_json)

				render 'show'
			end

			def create
				@delivery = Shoppe::DeliveryService.new(safe_params)
				@price = Shoppe::DeliveryServicePrice.new(price_safe_params)
				@price.save
				@delivery.delivery_service_prices = [@price]
				@delivery.save
				
				@errors = JSON.parse(@delivery.errors.to_json)

				render 'show'
		    end

		    def destroy
		    	@delivery.destroy

				render 'show'
		    end

			private

			def safe_params
				params[:delivery_service].permit(:active, :code, :default, :name, :tracking_url, :courier)
		    end

		    def price_safe_params
				params[:delivery_service_price].permit(:code, :price, :cost_price, :min_weight, :max_weight, :tax_rate_id)
		    end
		end
	end
end