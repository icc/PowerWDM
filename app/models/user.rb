class User < ActiveRecord::Base

  def id-name
    "#{id}-#{name.parameterize}"
  end
end
