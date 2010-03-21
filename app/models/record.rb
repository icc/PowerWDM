class Record < ActiveRecord::Base
  belongs_to :domain
  
  validates_associated :domain
  validates_format_of :name, :with => /^(([a-z0-9]|\*\.){1}[a-z0-9\.\-]|\*)$/i, :allow_nil => true
  validates_length_of :name, :maximum => 255
  validates_format_of :type, :with => /^(SOA|NS|MX|A|AAAA|CNAME|TXT|PTR|HWINFO|SRV|NAPTR)$/, :allow_nil => true
  validates_format_of :content, :with => /^[a-z0-9]{1}[a-z0-9\.\-]$/i, :allow_nil => true
  validates_length_of :content, :maximum => 255
  validates_numericality_of :ttl, :only_integer => true, :allow_nil => true
  validates_numericality_of :prio, :only_integer => true, :allow_nil => true
end
