class DomainsController < ApplicationController
  layout 'standard'
  before_filter :my_domain?, :except => [:index, :create]
  before_filter :cancel?, :only => :update

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
      redirect_to domains_url()
    else
      index
      render 'index'
    end
  end

  def edit
    index
    render 'index'
  end

  def update
    old_domain_name = @domain.name
    if @domain.update_attributes(params[:domain])
      if old_domain_name != @domain.name
        for record in @domain.records
          record.remove_domain_suffix(old_domain_name)
          record.set_domain_suffix()
          record.save
        end
      end
      flash[:success] = "Domain updated successfully."
      redirect_to domains_url()
    else
      edit
    end
  end

  def show
    redirect_to domain_records_url(:domain_id => @domain.pretty_url)
  end

  def destroy
    @domain.destroy
    flash['success'] = "#{@domain.name} was successfully removed."
    redirect_to domains_url()
  end

  private
    def my_domain?
      @domain = Domain.find params[:id].to_i
      redirect_to domains_url() if @logged_in_user.id != @domain.user_id and @logged_in_user.role != 'admin'
    end
    def cancel?
      redirect_to domains_url() if params[:commit] == 'Cancel'
    end
end
