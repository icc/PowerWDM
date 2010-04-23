module UsersHelper
  def determine_protocol
    if APP_CONFIG['https'] == 'user_data_only' and RAILS_ENV == 'production'
      'https' 
    else
      'http'
    end
  end
end
