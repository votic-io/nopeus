module Shoppe
  module Api
    class OrdersController < BaseApiController

      def show
        @order = Shoppe::Order.find(params[:id])
        render 'show'
      end

    	def current
    		@order = current_order
	     	render 'show'
    	end

      def delete
        @order = Shoppe::Order.find(params[:id])
        @order.destroy
      end

      def confirming
        @order = Shoppe::Order.find(params[:id])
        @order.attributes = params.permit(:first_name, :last_name, :company, :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_country_id, :billing_postcode, :email_address, :phone_number, :delivery_name, :delivery_address1, :delivery_address2, :delivery_address3, :delivery_address4, :delivery_postcode, :delivery_country_id, :separate_delivery_address)
        @order.ip_address = params[:ip]
        @order.proceed_to_confirm
        puts @order.errors.to_a
        render 'show'
      end

      def confirm
        @order = Shoppe::Order.find(params[:id])
        @order.confirm!
        render 'show'
      end

      def current_reset
        user_session_write :order_id, nil
        @order = current_order
        render 'show'
      end
    end
  end
end