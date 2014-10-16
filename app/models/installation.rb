class Installation < ActiveRecord::Base
  belongs_to :project
  belongs_to :server
end
