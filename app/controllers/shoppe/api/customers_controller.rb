module Shoppe
  module Api
    class CustomersController < BaseApiController

      def login
        @customer = Shoppe::Customer.authenticate(params[:email_address], params[:password])
        user_session_write :customer_id, @customer.id
        
        render 'show'
      end

      def logout
        user_session_write :customer_id, nil
        
        render 'show'
      end

      def register
        @customer = Shoppe::Customer.create(
          email: params[:email_address], 
          password: params[:password], 
          password_confirmation: params[:password_confirmation], 
          first_name: params[:first_name], 
          last_name: params[:last_name], 
          phone: params[:phone])
        @errors = JSON.parse(@customer.errors.to_json)
        unless @customer.errors.any?
          @customer = Shoppe::Customer.authenticate(params[:email_address], params[:password])
          user_session_write :customer_id, @customer.id
        end
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
        @customer ||= Shoppe::Customer.find(params[:id])
        #@addresses = @customer.addresses.ordered.load
        #@orders = @customer.orders.ordered.load
      end

      def create
        @customer = Shoppe::Customer.new(safe_params)
        if @customer.save
          redirect_to @customer, flash: { notice: t('shoppe.customers.created_successfully') }
        else
          render action: 'new'
        end
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
        params[:customer].permit(:first_name, :last_name, :company, :email, :phone, :mobile)
      end
    end
  end
end