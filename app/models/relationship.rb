class Relationship < ActiveRecord::Base
  belongs_to :left_model, class_name: 'Model', foreign_key: "left_model_id"
  belongs_to :right_model, class_name: 'Model', foreign_key: "right_model_id"
end
