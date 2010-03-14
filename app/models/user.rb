class User < ActiveRecord::Base
  validate :must_be_invited
  validates_presence_of :name, :password
  validates_uniqueness_of :name
  validates_confirmation_of :password
  validates_format_of :name, :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_length_of :name, :maximum => 255
  validates_length_of :password, :within => 6..40

  before_save :encrypt_password
  before_save :set_role
  before_save :remove_invite

  def pretty_url
    "#{id}-#{name.parameterize}"
  end

  def email
    name
  end

  def has_password?(p)
    if p == ""
      false
    else
      password == encrypt_password(p)
    end
  end

  private
    def must_be_invited
      errors.add_to_base("You're not invited.") if role.nil? and !Invite.find_by_name(name) and User.find(:all).size > 0
    end

    def encrypt_password(p = password)
      self.created_at = Time.now if created_at.nil?
      self.password = Digest::SHA2.hexdigest(created_at.to_s.reverse + p[0..3] + created_at.to_f.to_s + p[-p.length+4..-1] + created_at.to_i.to_s.reverse)
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
