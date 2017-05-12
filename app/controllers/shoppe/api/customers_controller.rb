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
        render 'show'
      end

      def current
        @customer = current_customer
        render 'show'
      end

      def index
        @query = Shoppe::Customer.ordered.page(params[:page]).search(params[:q])
        @customers = @query.result
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
        end
        render 'show'
      end

      def collect
        @customer ||= Shoppe::Customer.where(email_address: params[:email_address]).first
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

      private

      def safe_params
        params.permit(:first_name, :last_name, :company, :email_address, :phone_number, :mobile)
      end
    end
  end
end