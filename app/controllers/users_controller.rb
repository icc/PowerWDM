class UsersController < ApplicationController
  layout 'standard'

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
      flash[:success] = "Signup success!"
      session[:user_id] = @user.id
      redirect_to "/users"
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
      redirect_to "/users"
    else
      render 'edit'
    end
  end

  def destroy
    if @logged_in_user.role == 'admin'
      user = User.find params[:id]
      User.delete user.id
      flash['success'] = "User #{user.name} was successfully removed."
    end
    redirect_to '/users'
  end

  def login
    render 'login'
  end

  def authenticate
    user = User.find_by_name params[:name] 
    if user and user.has_password? params[:password]
      flash[:success] = "Login success!"
      session[:user_id] = user.id 
      redirect_to '/users'
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
    redirect_to '/users'
  end

  def promote
    if @logged_in_user.role == 'admin'
      user = User.find params[:id] 
      user.role = 'admin'
      if user.save(false)
        flash[:success] = "#{user.name} was successfully promoted to admin."
      end
    end
    redirect_to '/users'
  end

  def demote
    if @logged_in_user.role == 'admin'
      user = User.find params[:id]
      user.role = 'user'
      if user.save(false)
        flash[:success] = "#{user.name} was successfully demoted to regular user."
      end
    end
    redirect_to '/users'
  end
end
