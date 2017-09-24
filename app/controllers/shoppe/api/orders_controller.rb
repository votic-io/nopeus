module Shoppe
  module Api
    class OrdersController < BaseApiController

      include Shoppe::ProductsHelper

      def index
        @orders = Shoppe::Order.ordered.received.includes(order_items: :ordered_item)
        render 'index'
      end

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

      def change_delivery
        if params[:id].nil?
          params[:id] = current_order[:id]
        end
        @order = Shoppe::Order.find(params[:id])

        delivery_service = Shoppe::DeliveryService.find(params[:delivery_service_id])
        if delivery_service.present?
          @order.delivery_service = delivery_service
          @order.save
        end
        
        render 'show'
      end

      def delete
        @order = Shoppe::Order.find(params[:id])
        @order.destroy
      end

      def confirming
        @order = Shoppe::Order.find(params[:id])
        @order.attributes = params.permit(:first_name, :last_name, :company, :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_country_id, :billing_postcode, :email_address, :phone_number, :delivery_name, :delivery_address1, :delivery_address2, :delivery_address3, :delivery_address4, :delivery_postcode, :delivery_country_id, :separate_delivery_address)

        unless current_customer.nil?
          customer = current_customer
          @order.customer = customer
          if @order.billing_address1.present?
            customer.addresses.build(address_type: 'billing', address1: @order.billing_address1, address2: @order.billing_address2, address3: @order.billing_address3, address4: @order.billing_address4, country_id: @order.billing_country_id, postcode: @order.billing_postcode)
          end
          if @order.delivery_address1.present?
            customer.addresses.build(address_type: 'delivery', address1: @order.delivery_address1, address2: @order.delivery_address2, address3: @order.delivery_address3, address4: @order.delivery_address4, country_id: @order.delivery_country_id, postcode: @order.delivery_postcode)
          end
          customer.save
        end

        params.select{|k| !k.index('properties_').nil?}.each do |k,v|
          @order.properties[k.split('properties_')[1]] = v
        end
        @order.ip_address = params[:ip]
        @order.proceed_to_confirm
        @order.save
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
        params.select{|k| !k.index('properties_').nil?}.each do |k,v|
          @order.properties[k.split('properties_')[1]] = v
        end
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
        params.select{|k| !k.index('properties_').nil?}.each do |k,v|
          @order.properties[k.split('properties_')[1]] = v
        end
        @order.ship!
        render 'show'
      end

      def pending
        @orders = Shoppe::Order.pending.order(received_at: :asc)
        render 'index'
      end

      def notify
        @order = Shoppe::Order.find(params[:id])
        unless @order.nil?
          @order.properties.delete 'print'
          @order.save
        else
          @order = Shoppe::Order.new
        end
        render 'show'
      end

      def reprint
        @order = Shoppe::Order.find(params[:id])
        unless @order.nil?
          @order.properties['print'] = 'reprint'
          @order.save
        else
          @order = Shoppe::Order.new
        end
        render 'show'
      end      

      def delivery_services
        @order = Shoppe::Order.find(params[:id])
        unless @order.nil?
          @delivery_services = @order.available_delivery_services
        else
          @delivery_services = []
        end
        render 'delivery_services'
      end

      def accepted
        @orders = Shoppe::Order.accepted.order(received_at: :asc)
        render 'index'
      end

      def printing
        @orders = Shoppe::Order.accepted.select{|e| e.properties['print'].present?}
        @orders += Shoppe::Order.shipped.select{|e| e.properties['print'].present?}
        render 'index'
      end

      def current_reset
        user_session_write :order_id, nil
        @order = current_order
        render 'show'
      end
    end
  end
end