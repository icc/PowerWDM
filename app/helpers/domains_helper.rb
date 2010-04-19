module DomainsHelper
  def owner
    if @domain.user_id.nil?
      @logged_in_user.id
    else
      @domain.user_id
    end
  end
  def type_selected
    if @domain.type.nil?
      'NATIVE'
    else
      @domain.type
    end
  end
end
