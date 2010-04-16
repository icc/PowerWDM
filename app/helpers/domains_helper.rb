module DomainsHelper
  def selected?
    if @domain.user_id.nil?
      @logged_in_user.id
    else
      @domain.user_id
    end
  end
end
