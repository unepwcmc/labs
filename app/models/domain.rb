class Domain < ActiveRecord::Base
  belongs_to :project
  has_many :models
end
