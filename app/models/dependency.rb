class Dependency < ActiveRecord::Base
  belongs_to :master_project, :class_name => "Project"
  belongs_to :sub_project, :class_name => "Project"
end
