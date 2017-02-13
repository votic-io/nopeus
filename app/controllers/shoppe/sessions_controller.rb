module Shoppe
  class SessionsController < Shoppe::ApplicationController
    layout 'shoppe/sub'
    skip_before_filter :login_required, only: [:new, :create]

    def create
      if user = Shoppe::User.authenticate(params[:email_address], params[:password])
        session[:shoppe_user_id] = user.id
        
        application = Shoppe::Application.find(user.application_id)
        
        Thread.current[:app_token] = application.token
        session[:app_token] = application.token
        Thread.current[:application] = application

        redirect_to :orders
      else
        flash.now[:alert] = t('shoppe.sessions.create_alert')
        render action: 'new'
      end
    end

    def destroy
      session[:shoppe_user_id] = nil
      redirect_to :login
    end
  end
end
