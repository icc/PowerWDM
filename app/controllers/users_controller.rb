class UsersController < ApplicationController
  layout 'standard'

  def new
    @user = User.new    
  end

  def create
    @user = User.new params[:user]
    if @user.save
      flash[:success] = "Signup success!"
      redirect_to "/users/#{@user.pretty_url}"
    else
      render 'new'
    end
  end

  def show
    @user = User.find params[:id]
  end

  def edit
  end

  def update
  end

  def destroy
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
      flash[:error] = "Invalid username and/or password"
      redirect_to "/login"
    end
  end

  def sign_off
    session[:user_id] = nil
    flash[:success] = "Have a nice day."
    redirect_to "/login"
  end
end
