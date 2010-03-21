class Domain < ActiveRecord::Base
  belongs_to :user
  has_many :records, :dependent => :destroy 

  validates_associated :records, :user
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_format_of :name, :with => /^[a-z0-9]{1}[a-z0-9\.\-]$/i
  validates_length_of :name, :maximum => 255
  validates_format_of :master, :with => /^[a-z0-9]{1}[a-z0-9\.\-]$/i, :allow_nil => true
  validates_length_of :master, :maximum => 128
  validates_presence_of :type
  validates_format_of :type, :with => /^(NATIVE|MASTER|SLAVE)$/
end
