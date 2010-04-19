class User < ActiveRecord::Base
  has_many :domains, :dependent => :destroy 
  attr_accessor :current_password

  validate :must_be_invited
  validates_presence_of :name, :password
  validates_uniqueness_of :name
  validates_confirmation_of :password
  validates_format_of :name, :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_length_of :name, :maximum => 255
  validates_length_of :password, :within => 6..40
  validate_on_update :old_password

  after_validation :set_password
  before_create :set_role
  before_create :remove_invite

  def pretty_url
    "#{id}-#{name.parameterize}"
  end

  def email
    name
  end

  def has_password?(p)
    password == encrypt_password(p)
  end

  def first_user?
    id == User.find(:first, :order => 'created_at').id
  end

  private
    def must_be_invited
      errors.add_to_base("You're not invited.") if role.nil? and !Invite.find_by_name(name) and User.find(:all).size > 0
    end

    def old_password
      errors.add :current_password, 'is wrong.' unless User.find(id).has_password?(current_password)
    end

    def encrypt_password(p)
      self.created_at = Time.now if created_at.nil?
      Digest::SHA2.hexdigest(created_at.to_s.reverse + p[0..3] + created_at.to_f.to_s + p[-p.length+4..-1] + created_at.to_i.to_s.reverse)
    rescue
    end

    def set_password(p = password)
      self.password = encrypt_password(p)
    end

    def set_role
      if User.find(:all).size > 0
        self.role = 'user'
      else
        self.role = 'admin'
      end
    end

    def remove_invite
      Invite.delete_all("name = '#{name}'")
    end
end
