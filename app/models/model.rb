class Model < ActiveRecord::Base
  belongs_to :domain
  has_many :columns
  has_many :left_relationships, class_name: "Relationship", foreign_key: "left_model_id"
  has_many :right_relationships, class_name: "Relationship", foreign_key: "right_model_id"
end
