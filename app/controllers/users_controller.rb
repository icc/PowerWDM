class UsersController < ApplicationController
  layout 'standard'
  before_filter :logged_in?, :except => [:new, :create, :login, :authenticate]
  before_filter :redirect_logged_in, :only => [:new, :create, :login, :authenticate]
  before_filter :admin?, :only => [:index, :destroy, :promote, :demote, :create_invite, :destroy_invite]
  before_filter :first_user?, :only => [:destroy, :demote]
  before_filter :check_login_attempts, :only => :authenticate

  def index
    @title = 'Users'

    @users = User.find :all, :order => 'created_at'
    @invites = Invite.find :all

    @invite = Invite.new unless @invite
  end

  def new
    @title = 'Sign up'

    @user = User.new
    retrive_error_messages @user.errors unless flash[:stored_errors].nil?
  end

  def create
    @user = User.new params[:user]
    if @user.save
      flash[:success] = "Signup success, welcome."
      session[:user_id] = @user.id
      redirect_to :controller => 'domains', :protocol => determine_protocol
    else
      store_error_messages @user.errors
      redirect_to :action => 'new', :controller => 'users', :protocol => determine_protocol
    end
  end

  def edit
    @title = "Change password"
    retrive_error_messages @logged_in_user.errors unless flash[:stored_errors].nil?
  end

  def update    
    if @logged_in_user.update_attributes(params[:user])
      flash[:success] = "Password changed."
      redirect_to :controller => 'domains', :protocol => determine_protocol
    else
      store_error_messages @logged_in_user.errors
      redirect_to :id => @logged_in_user.pretty_url, :action => 'edit', :controller => 'users', :protocol => determine_protocol
    end
  end

  def destroy
    @user.destroy
    flash['success'] = "User #{@user.name} was successfully removed."
    redirect_to users_url()
  end

  def login
    @title = 'Login'
  end

  def authenticate
    user = User.find_by_name params[:name] 
    if user and user.has_password? params[:password]
      # Login success
      flash[:success] = "Login success, welcome."
      session[:user_id] = user.id 
      redirect_to :controller => 'domains', :protocol => determine_protocol
    else
      # Login failed
      session[:failed_login_attempts] += 1
      if session[:failed_login_attempts] >= APP_CONFIG['max_login_attempts']
        flash[:error] = "You've used up all your login attempts.<br/>Please come back later."
      else
        flash[:error] = "Invalid username and/or password."
      end
      redirect_to :action => 'login', :controller => 'users', :protocol => determine_protocol
    end
  end

  def sign_off
    session[:user_id] = nil
    session[:failed_login_attempts] = nil
    flash[:success] = "Have a nice day."
    redirect_to "/login"
  end
  
  def create_invite
    @invite = Invite.new params[:invite]
    if @invite.save
      flash[:success] = "Invite success!"
      redirect_to '/users'
    else 
      index
      render 'index'
    end
  end

  def destroy_invite
    Invite.delete params[:id]
    redirect_to users_url()
  end

  def promote
    user = User.find params[:id] 
    user.role = 'admin'
    if user.save(false)
      flash[:success] = "#{user.name} was successfully promoted to admin."
    end
    redirect_to users_url()
  end

  def demote
    @user.role = 'user'
    if @user.save(false)
      flash[:success] = "#{@user.name} was successfully demoted to regular user."
    end
    redirect_to users_url()
  end

  private
    def logged_in?
      redirect_to '/login' if @logged_in_user.nil?
    end
    def redirect_logged_in
      redirect_to domains_url() unless @logged_in_user.nil?
    end
    def admin?
      redirect_to domains_url() unless @logged_in_user.role == 'admin'
    end
    def first_user?
      @user = User.find params[:id]
      redirect_to users_url() if @user.first_user?
    end
    def determine_protocol
      if APP_CONFIG['https'] == 'all' and RAILS_ENV == 'production'
        'https'
      else
        'http'
      end
    end
    def store_error_messages errors
      flash[:stored_errors] = Array.new
      errors.each {|attr, msg| flash[:stored_errors] << Array.[](attr, msg)}
    end
    def retrive_error_messages errors
      for error in flash[:stored_errors] do
        errors.add error[0], error[1]
      end
    end
    def check_login_attempts
      if session[:failed_login_attempts].nil?
        session[:failed_login_attempts] = 0
      elsif !session[:blocked_at].nil? and Time.now.to_i > session[:blocked_at] + APP_CONFIG['wait_before_login']
        # Timed out, reset counter
        session[:failed_login_attempts] = 0
        session[:blocked_at] = nil
      elsif session[:failed_login_attempts] >= APP_CONFIG['max_login_attempts'] 
        # Block the user
        session[:blocked_at] = Time.now.to_i
        flash[:error] = "You've used up all your login attempts.<br/>Please come back later."
        redirect_to :action => 'login', :controller => 'users', :protocol => determine_protocol
      end
    end
end
