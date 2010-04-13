class UsersController < ApplicationController
  layout 'standard'
  before_filter :logged_in?, :except => [:new, :create, :login, :authenticate]
  before_filter :redirect_logged_in, :only => [:new, :create, :login, :authenticate]
  before_filter :admin?, :only => [:index, :destroy, :promote, :demote, :create_invite, :destroy_invite]

  def index
    @users = User.find :all
    @invites = Invite.find :all

    @invite = Invite.new unless @invite
  end

  def new
    @user = User.new    
  end

  def create
    @user = User.new params[:user]
    if @user.save
      flash[:success] = "Signup success, welcome."
      session[:user_id] = @user.id
      redirect_to users_url()
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @logged_in_user.password = params[:user][:password]
    @logged_in_user.password_confirmation = params[:user][:password_confirmation]
    if @logged_in_user.save
      flash[:success] = "Password changed."
      redirect_to users_url()
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find params[:id]
    user.destroy
    flash['success'] = "User #{user.name} was successfully removed."
    redirect_to users_url()
  end

  def login
  end

  def authenticate
    user = User.find_by_name params[:name] 
    if user and user.has_password? params[:password]
      flash[:success] = "Login success, welcome."
      session[:user_id] = user.id 
      redirect_to domains_url()
    else
      flash[:error] = "Invalid username and/or password."
      redirect_to "/login"
    end
  end

  def sign_off
    session[:user_id] = nil
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
    user = User.find params[:id]
    user.role = 'user'
    if user.save(false)
      flash[:success] = "#{user.name} was successfully demoted to regular user."
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
end
