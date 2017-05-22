module Shoppe
  module Api
    class UsersController < BaseApiController

      before_filter :prevent_missing_token, except: [:current, :login]

      def current
    		@user = current_user
        render 'show'
    	end

      def show
        @user ||= Shoppe::User.find(params[:id])
        render 'show'
      end

      def login
        @user = Shoppe::User.authenticate(params[:email_address], params[:password])
        puts "--------------------------------------customer"
        puts @user
        if @user
          puts "OK"
          user_session_write :user_id, @user.id

          application = Shoppe::Application.find(@user.application_id)
          Thread.current[:app_token] = application.token
          user_session_write :app_token, application.token
          Thread.current[:application] = application
        else
          puts "NOK"
          @user = Shoppe::User.new
          @errors = {'invalid' => ["Incorrect email or password"]}
        end
        render 'show'
      end

      def logout
        user_session_write :user_id, nil
        @user = Shoppe::User.new
        render 'show'
      end

    end
  end
end