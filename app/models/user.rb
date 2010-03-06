class User < ActiveRecord::Base
  validates_presence_of :name, :password
  validates_uniqueness_of :name
  validates_confirmation_of :password
  validates_format_of :name, :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_length_of :name, :maximum => 255
  validates_length_of :password, :within => 6..40

  before_save :encrypt_password

  def pretty_url
    "#{id}-#{name.parameterize}"
  end

  def email
    name
  end

  def has_password?(p)
    password == encrypt_password(p, created_at)
  end

  private
    def encrypt_password(p = password, t = Time.now)
      self.password = Digest::SHA2.hexdigest(t.yday.to_s + p[0..1] + t.strftime("%b") + p[2..3] + t.strftime("%a") + p[-p.length+4..-1] + t.strftime("%p%U"))
    end
end
