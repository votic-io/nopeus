module Shoppe
  class ApplicationController < ActionController::Base
    protect_from_forgery

    before_filter :setup_application
    before_filter :scope_validations
    before_filter :login_required
    around_filter :catch_exceptions

    rescue_from ActiveRecord::DeleteRestrictionError do |e|
      redirect_to request.referer || root_path, alert: e.message
    end

    rescue_from Shoppe::Error do |e|
      @exception = e
      render layout: 'shoppe/sub', template: 'shoppe/shared/error'
    end

    private

    def catch_exceptions
      yield
      rescue => exception
      puts "Caught exception! #{exception}" 
      puts params
      print exception.backtrace.join("\n")

      respond_to do |format|
        #format.json
        format.html { render json: {:data => exception}, :status => 500}
        
        if params[:callback]
          format.js { render :json => {:data => exception}, :status => 500, :callback => params[:callback] }
        else
          format.json { render json: {:data => exception}, :status => 500}
        end
      end
    end

    def setup_application
      puts "01-#{Thread.current[:app_token]}-#{Thread.current[:application]}"
      Thread.current[:app_token] = params[:app_token]
      puts "02-#{Thread.current[:app_token]}-#{Thread.current[:application]}"
      Thread.current[:app_token] ||= session[:app_token]
      puts "03-#{Thread.current[:app_token]}-#{Thread.current[:application]}"
      
      Thread.current[:application] = Shoppe::Application.current.first
      puts "04-#{Thread.current[:app_token]}-#{Thread.current[:application]}"
      if Thread.current[:application].nil?
        session[:app_token] = nil
        session[:shoppe_user_id] = nil
      end
    end

    def scope_validations
      Thread.current[:active_status] = true
      if params[:include_inactive].present?
        Thread.current[:active_status] = [true, false]
      end
    end

    def login_required
      redirect_to login_path unless logged_in?
    end

    def logged_in?
      current_user.is_a?(User)
    end

    def current_user
      @current_user ||= login_from_session || login_with_demo_mode || :false
    end

    def login_from_session
      if session[:shoppe_user_id]
        @user = User.find_by_id(session[:shoppe_user_id])
      end
    end

    def login_with_demo_mode
      @user = User.first if Shoppe.settings.demo_mode?
    end

    helper_method :current_user, :logged_in?
  end
end
