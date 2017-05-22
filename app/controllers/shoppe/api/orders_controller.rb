module Shoppe
  module Api
    class OrdersController < BaseApiController

      include Shoppe::ProductsHelper

      def show
        @order = Shoppe::Order.find(params[:id])
        render 'show'
      end

    	def current
    		@order = current_order
        @errors = {}
        render 'show'
    	end

      def add
        if params[:id].nil?
          params[:id] = current_order[:id]
        end
        @order = Shoppe::Order.find(params[:id])

        params[:quantity] ||= 1
        @product = fetch_product params[:product_id]
        @order.order_items.add_item(@product, params[:quantity].to_i) 
        @order = Shoppe::Order.find(params[:id])
        render 'show'
      end

      def remove
        if params[:id].nil?
          params[:id] = current_order[:id]
        end
        @order = Shoppe::Order.find(params[:id])

        product = fetch_product params[:product_id]
        item = @order.order_items.select{|e| e.ordered_item_id == product.id}.first
        item.remove
        @order = Shoppe::Order.find(params[:id])
        render 'show'
      end

      def increase
        if params[:id].nil?
          params[:id] = current_order[:id]
        end
        @order = Shoppe::Order.find(params[:id])

        product = fetch_product params[:product_id]
        item = @order.order_items.select{|e| e.ordered_item_id == product.id}.first
        item.increase!
        @order = Shoppe::Order.find(params[:id])
        render 'show'
      end

      def decrease
        if params[:id].nil?
          params[:id] = current_order[:id]
        end
        @order = Shoppe::Order.find(params[:id])

        product = fetch_product params[:product_id]
        item = @order.order_items.select{|e| e.ordered_item_id == product.id}.first
        item.decrease!
        @order = Shoppe::Order.find(params[:id])
        render 'show'
      end

      def delete
        @order = Shoppe::Order.find(params[:id])
        @order.destroy
      end

      def confirming
        @order = Shoppe::Order.find(params[:id])
        @order.attributes = params.permit(:first_name, :last_name, :company, :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_country_id, :billing_postcode, :email_address, :phone_number, :delivery_name, :delivery_address1, :delivery_address2, :delivery_address3, :delivery_address4, :delivery_postcode, :delivery_country_id, :separate_delivery_address)

        if params[:email].present?
          customer = Shoppe::Customer.where(email: params[:email]).first_or_create
          @order.customer = customer
        end

        params.select{|k| !k.index('properties_').nil?}.each do |k,v|
          @order.properties[k.split('properties_')[1]] = v
        end
        @order.ip_address = params[:ip]
        @order.proceed_to_confirm
        @errors = JSON.parse(@order.errors.to_json)
        render 'show'
      end

      def confirm
        @order = Shoppe::Order.find(params[:id])
        @order.confirm!
        render 'show'
      end

      def accept
        @order = Shoppe::Order.find(params[:id])
        @order.accept!
        render 'show'
      end

      def reject
        @order = Shoppe::Order.find(params[:id])
        @order.reject!
        render 'show'
      end

      def ship
        @order = Shoppe::Order.find(params[:id])
        @order.ship!
        render 'show'
      end

      def pending
        @orders = Shoppe::Order.pending.order(received_at: :asc)
        render 'index'
      end

      def notify
        @order = Shoppe::Order.accepted.order(accepted_at: :asc).first
        unless @order.nil?
          @order.notify!
        else
          @order = Shoppe::Order.new
        end
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