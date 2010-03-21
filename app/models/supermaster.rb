class Supermaster < ActiveRecord::Base

  validates_presence_of :ip
  validates_format_of :ip, :with => /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/
  validates_presence_of :nameserver
  validates_format_of :nameserver, :with => /^[a-z0-9]{1}[a-z0-9\.\-]$/i
  
end
