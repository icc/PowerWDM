class Invite < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_length_of :name, :maximum => 255

  def email
    name
  end
end
