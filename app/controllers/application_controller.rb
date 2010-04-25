# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :check_https
  before_filter :check_last_action
  before_filter :find_logged_in_user
  before_filter :logged_in?, :except => :users

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  private
    def check_https
      redirect_to :protocol => 'https' if APP_CONFIG['https'] == 'all' and !request.ssl? and RAILS_ENV == 'production'
    end
    def check_last_action
      if !session[:last_action].nil? and !session[:user_id].nil? and Time.now.to_i > session[:last_action] + APP_CONFIG['time_out']
        session[:user_id] = nil
        flash[:error] = "Your session has expired."
      end
      session[:last_action] = Time.now.to_i
    end
    def find_logged_in_user
      if session[:user_id]
        @logged_in_user = User.find session[:user_id]
      end
    rescue
      session[:user_id] = nil
    end
    def logged_in?
      redirect_to '/login' if @logged_in_user.nil?
    end
end
