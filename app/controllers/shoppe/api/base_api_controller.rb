module Shoppe
  module Api
    class BaseApiController < ApplicationController
      before_filter :collect_session_id
      before_filter :prevent_missing_token
      around_filter :catch_exceptions
      skip_before_filter :login_required
      #before_filter :parse_request, :authenticate_user_from_token!
      #before_filter :parse_request


      private
        def setup_application
          Thread.current[:app_token] ||= params[:app_token]
          Thread.current[:app_token] ||= session[:app_token]
          Thread.current[:app_token] ||= user_session[:app_token]
          
          Thread.current[:application] = Shoppe::Application.current.first
          if Thread.current[:application].nil?
            session[:app_token] = nil
            session[:shoppe_user_id] = nil
          end
        end

        def prevent_missing_token
          if Thread.current[:application].nil?
            render json: {status: 403, message: 'Unauthorized access'}, status: 403
          end
          puts "------------------------------------params"
          puts params
        end

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

        def user_session
          session_id = Thread.current[:session_id]
          session = Rails.cache.read("USER_SESSION_#{session_id}")
          puts "------session------------------------------------------------"
          puts session
          puts "------------------------------------------------------"
          if session.nil?
            session = {id: session_id}
            Rails.cache.write("USER_SESSION_#{session_id}", session)
          end
          return  session
        end

        def user_session_write key, value
          session = user_session
          session[key] = value
          session_id = Thread.current[:session_id]
          
          Rails.cache.write("USER_SESSION_#{session_id}", session)
        end

        def collect_session_id
          Thread.current[:session_id] = params[:session_id]
          Thread.current[:session_id] ||= request.session_options[:id]
        end

        def current_user
          user_id = user_session[:user_id]

          Shoppe::User.where(id: user_id).first
        end

        def current_order
          @current_order ||= begin
            if has_order?
              @current_order
            else
              order = Shoppe::Order.create(:ip_address => request.ip)
              user_session_write :order_id, order.id
              order
            end
          end
        end

        def has_order?
          !!(
            user_session[:user_id] &&
            @current_order = Shoppe::Order.includes(:order_items => :ordered_item).find_by_id(user_session[:order_id])
          )
        end

        helper_method :current_order, :has_order?, :user_session, :user_session_write
    end
  end
end