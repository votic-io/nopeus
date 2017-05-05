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
        user_session_write :user_id, @user.id
        
        application = Shoppe::Application.find(@user.application_id)
        
        Thread.current[:app_token] = application.token
        user_session_write :app_token, application.token
        Thread.current[:application] = application

        render 'show'
      end

    end
  end
end