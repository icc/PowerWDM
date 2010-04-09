class Record < ActiveRecord::Base
  set_inheritance_column :ruby_type
  belongs_to :domain
  
  validates_associated :domain
  validates_format_of :name, :with => /^(([a-z0-9]|\*\.){1}[a-z0-9\.\-]*|\*)$/i, :allow_nil => true
  validates_length_of :name, :maximum => 255
  validates_format_of :type, :with => /^(SOA|NS|MX|A|AAAA|CNAME|TXT|PTR|HWINFO|SRV|NAPTR)$/, :allow_nil => true
  validates_format_of :content, :with => /^[a-z0-9]{1}[a-z0-9\.\-\s]*$/i, :allow_nil => true
  validates_length_of :content, :maximum => 255
  validates_numericality_of :ttl, :only_integer => true, :allow_nil => true
  validates_numericality_of :prio, :only_integer => true, :allow_nil => true

  before_validation :set_suffix
  before_save :set_change_date

  def pretty_url
    "#{id}-#{name.parameterize}-in-#{type.parameterize}-#{content.parameterize}"
  end

  private
    def set_change_date
      self.change_date = Time.now.to_i
    end
    def set_suffix
      domain = Domain.find domain_id
      if name.blank?
        self.name = domain.name
      else
        self.name = name + '.' + domain.name if name.scan(/#{domain.name}$/).empty?
      end
    end
end
