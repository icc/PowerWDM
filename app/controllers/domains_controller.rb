class DomainsController < ApplicationController
  layout 'standard'
  before_filter :my_domain?, :except => [:index, :create]

  def index
    if @logged_in_user.role == 'admin'
      @domains = Domain.find :all
    else
      @domains = @logged_in_user.domains
    end
    @domain = Domain.new unless @domain
  end

  def create
    @domain = Domain.new params[:domain]
    @domain.user_id = @logged_in_user.id unless @logged_in_user.role == 'admin'
    if @domain.save
      flash[:success] = "Domain creation success."
      redirect_to "/domains"
    else
      index
      render 'index'
    end
  end

  def show
    redirect_to "/domains/#{params[:id]}/records/"
  end

  def destroy
    @domain.destroy
    flash['success'] = "#{@domain.name} was successfully removed."
    redirect_to "/domains"
  end

  private
    def my_domain?
      @domain = Domain.find params[:id].to_i
      redirect_to '/domains' if @logged_in_user.id != @domain.user_id and @logged_in_user.role != 'admin'
    end
end
