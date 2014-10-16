class Server < ActiveRecord::Base
  has_many :installations
  has_many :projects, through: :installations
end
