class Domain < ActiveRecord::Base
  set_inheritance_column :ruby_type

  belongs_to :user
  has_many :records, :dependent => :destroy, :order => 'created_at'

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_format_of :name, :with => /^[a-z0-9]{1}[a-z0-9\.\-]*$/i
  validates_length_of :name, :maximum => 255
  validates_format_of :master, :with => /^[a-z0-9]{1}[a-z0-9\.\-]*$/i, :allow_blank => true
  validates_length_of :master, :maximum => 128
  validates_presence_of :type
  validates_format_of :type, :with => /^(NATIVE|MASTER|SLAVE)$/

  before_validation :check_type
  after_create :create_soa_record if :config_valid?

  def pretty_url
    "#{id}-#{name.parameterize}"
  end

  private
    def check_type
      self.master = "" unless self.type == "SLAVE"
    end
    def create_soa_record
      soa = Record.new
      soa.domain_id = self.id
      soa.name = self.name
      soa.type = 'SOA'
      first_name_server = APP_CONFIG['name_servers'].first.gsub(/\_domain\_name\_$/, self.name)
      soa.content = APP_CONFIG['soa_record']['primary'].gsub(/^\_first\_name\_server\_$/, first_name_server) + ' '
      soa.content += APP_CONFIG['soa_record']['hostmaster'].gsub(/^\_user\_name\_$/, self.user.name.gsub(/\@/, '.')) + ' '
      soa.content += APP_CONFIG['soa_record']['serial'].to_s + ' '
      soa.content += APP_CONFIG['soa_record']['refresh'].to_s + ' '
      soa.content += APP_CONFIG['soa_record']['retry'].to_s + ' '
      soa.content += APP_CONFIG['soa_record']['expire'].to_s + ' '
      soa.content += APP_CONFIG['soa_record']['default_ttl'].to_s
      soa.save
      for name_server in APP_CONFIG['name_servers']
        create_ns_record(name_server.gsub(/\_domain\_name\_$/, self.name))
      end
    end
    def create_ns_record(content)
      ns = Record.new
      ns.domain_id = self.id
      ns.name = self.name
      ns.type = 'NS'
      ns.content = content
      ns.save
    end
    def config_valid?
      if APP_CONFIG['name_servers'].nil? or
         APP_CONFIG['name_servers'].first.nil? or
         APP_CONFIG['soa_record'].nil? or
         APP_CONFIG['soa_record']['primary'].nil? or
         APP_CONFIG['soa_record']['hostmaster'].nil? or
         APP_CONFIG['soa_record']['serial'].nil? or
         APP_CONFIG['soa_record']['refresh'].nil? or
         APP_CONFIG['soa_record']['retry'].nil? or
         APP_CONFIG['soa_record']['expire'].nil? or
         APP_CONFIG['soa_record']['default_ttl'].nil?
        return false
      end
      return true
    end
end
