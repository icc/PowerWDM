class RecordsController < ApplicationController
  layout 'standard'
  before_filter :my_domain?
  before_filter :cancel?, :only => :update
  before_filter :back?, :only => :create

  def index
    @title = @domain.name

    @records = @domain.records
    if @record.nil?
      @record = Record.new 
    else 
      @record.remove_domain_suffix
    end
  end

  def create
    @record = Record.new params[:record]
    @record.domain_id = params[:domain_id].to_i
    if @record.save
      flash[:success] = "Record added to domain."
      redirect_to domain_records_url(:domain_id => @domain.pretty_url)
    else
      index
      render 'index'
    end
  end

  def edit
    @record = Record.find params[:id] unless @record
    index
    render 'index'
  end

  def update
    @record = Record.find params[:id]
    if @record.update_attributes(params[:record])
      flash[:success] = "Record updated successfully."
      redirect_to domain_records_url(:domain_id => @domain.pretty_url)
    else    
      edit
    end
  end

  def destroy
    record = Record.find params[:id]
    record.destroy
    flash['success'] = "Record was successfully removed."
    redirect_to domain_records_url(:domain_id => @domain.pretty_url)
  end

  private
    def my_domain?
      @domain = Domain.find params[:domain_id].to_i
      redirect_to domains_url() if @logged_in_user.id != @domain.user_id and @logged_in_user.role != 'admin'
    end
    def cancel?
      redirect_to domain_records_url(:domain_id => @domain.pretty_url) if params[:commit] == 'Cancel'
    end
    def back?
      redirect_to domains_url if params[:commit] == 'Back'
    end
end
