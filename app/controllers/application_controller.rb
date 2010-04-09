# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :find_logged_in_user
  before_filter :logged_in?, :except => :users

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  private
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
