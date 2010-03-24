class DomainsController < ApplicationController
  layout 'standard'

  def index
    if @logged_in_user.role == 'admin'
      @domains = Domain.find :all
    else
      @domains = @logged_in_user.domains
    end
    @domain = Domain.new
  end

  def create
    @domain = Domain.new params[:domain]
    if @logged_in_user.role == 'admin'
      @domain.user_id = params[:domain][:user_id]
    else
      @domain.user = @logged_in_user
    end 
    if @domain.save
      flash[:success] = "Domain creation success."
      redirect_to "/domains"
    else
      @domains = Domain.find :all
      render 'index'
    end
  end
end
