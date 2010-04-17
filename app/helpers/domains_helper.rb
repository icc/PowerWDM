module DomainsHelper
  def owner
    @domain.user_id
  rescue
    @logged_in_user.id
  end
end
