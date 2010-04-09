class Domain < ActiveRecord::Base
  set_inheritance_column :ruby_type

  belongs_to :user
  has_many :records, :dependent => :destroy, :order => 'name, created_at'

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_format_of :name, :with => /^[a-z0-9]{1}[a-z0-9\.\-]*$/i
  validates_length_of :name, :maximum => 255
  validates_format_of :master, :with => /^[a-z0-9]{1}[a-z0-9\.\-]*$/i, :allow_blank => true
  validates_length_of :master, :maximum => 128
  validates_presence_of :type
  validates_format_of :type, :with => /^(NATIVE|MASTER|SLAVE)$/

  before_validation :check_type
  after_save :create_soa_record

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
      soa.content = 'ns.' + self.name + ' hostmaster.' + self.name + ' 0 10800 3600 604800 3600'
      soa.save
    end
end
