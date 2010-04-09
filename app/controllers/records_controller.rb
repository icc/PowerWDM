class RecordsController < ApplicationController
  layout 'standard'
  before_filter :my_domain?

  def index
    @records = @domain.records
    @record = Record.new unless @record
  end

  def create
    @record = Record.new params[:record]
    @record.domain_id = params[:domain_id].to_i
    if @record.save
      flash[:success] = "Record added to domain."
      redirect_to "/domains/#{params[:domain_id]}/records"
    else
      index
      render 'index'
    end
  end

  def destroy
    record = Record.find params[:id]
    Record.delete record.id
    flash['success'] = "Record was successfully removed."
    redirect_to "/domains/#{record.domain.pretty_url}/records/"
  end

  private
    def my_domain?
      @domain = Domain.find params[:domain_id].to_i
      redirect_to '/domains' if @logged_in_user.id != @domain.user_id and @logged_in_user.role != 'admin'
    end
end
