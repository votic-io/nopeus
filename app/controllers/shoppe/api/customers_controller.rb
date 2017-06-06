module Shoppe
  module Api
    class CustomersController < BaseApiController

      def login
        @customer = Shoppe::Customer.authenticate(params[:email_address], params[:password])
        puts "--------------------------------------customer"
        puts @customer
        if @customer
          puts "OK"
          user_session_write :customer_id, @customer.id
          attach_order @customer
        else
          puts "NOK"
          @customer = Shoppe::Customer.new
          @errors = {'invalid' => ["Incorrect email or password"]}
        end
        render 'show'
      end

      def logout
        user_session_write :customer_id, nil
        @customer = Shoppe::Customer.new

        dettach_order
        render 'show'
      end

      def current
        @customer = current_customer
        render 'show'
      end

      def index
        @query = Shoppe::Customer.ordered
        @customers = @query.page(params[:page]).search(params[:q]).result
      end

      def new
        @customer = Shoppe::Customer.new
      end

      def show
        unless params[:id].index('@').nil?
          @customer ||= Shoppe::Customer.where(email_address: params[:id]).first
          if @customer.nil?
            @customer = Shoppe::Customer.new
          end
        else
          @customer ||= Shoppe::Customer.find(params[:id])
        end
      end

      def create
        unless params[:automatic_password].nil?
          params[:password] = SecureRandom.hex(8)
          params[:password_confirmation] = params[:password]
          autogenerated = true
        end
        @customer = Shoppe::Customer.create(
          email_address: params[:email_address], 
          password: params[:password], 
          password_confirmation: params[:password_confirmation], 
          first_name: params[:first_name], 
          last_name: params[:last_name], 
          phone_number: params[:phone_number])
        if params[:billing_address1].present?
          @customer.addresses.build(address_type: 'billing', address1: params[:billing_address1], address2: params[:billing_address2], address3: params[:billing_address3], address4: params[:billing_address4], country_id: params[:billing_country_id], postcode: params[:billing_postcode])
          @customer.addresses.build(address_type: 'delivery', address1: params[:billing_address1], address2: params[:billing_address2], address3: params[:billing_address3], address4: params[:billing_address4], country_id: params[:billing_country_id], postcode: params[:billing_postcode])
        end
        @errors = JSON.parse(@customer.errors.to_json)
        unless @customer.errors.any?
          @customer.properties['source'] = params['properties_source']
          @customer.save

          @customer = Shoppe::Customer.authenticate(params[:email_address], params[:password])
          user_session_write :customer_id, @customer.id

          if autogenerated
            @customer.properties['autogenerated'] = true
            @customer.save
          end

          attach_order @customer
        end
        render 'show'
      end

      def collect
        @customer ||= Shoppe::Customer.where(email_address: params[:email_address]).first
        render 'show'
      end

      def change_password
        id = params[:token].split('_')[0]
        password_digest = params[:token].split('_')[1]

        @customer = Shoppe::Customer.where(id: id, password_digest: password_digest).first
        if @customer.present?
          @customer.password = params[:password]
          @customer.password_confirmation = params[:password_confirmation]
          @customer.save
        else
          @customer = Shoppe::Customer.new
          @errors = {'invalid' => ["This token has expired"]}
        end

        render 'show'
      end

      def update
        if @customer.update(safe_params)
          redirect_to @customer, flash: { notice: t('shoppe.customers.updated_successfully') }
        else
          render action: 'edit'
        end
      end

      def destroy
        @customer.destroy
        redirect_to customers_path, flash: { notice: t('shoppe.customers.deleted_successfully') }
      end

      def search
        index
        render action: 'index'
      end

      def orders
        @customer = Shoppe::Customer.find(params[:id])     
        @orders = @customer.orders.received.order(received_at: :desc)
      end

      private

      def safe_params
        params.permit(:first_name, :last_name, :company, :email_address, :phone_number, :mobile)
      end
    end
  end
end