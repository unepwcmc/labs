class Model < ActiveRecord::Base
  belongs_to :domain
  has_many :columns, dependent: :destroy
  has_many :left_relationships, class_name: "Relationship", foreign_key: "left_model_id", dependent: :destroy
  has_many :right_relationships, class_name: "Relationship", foreign_key: "right_model_id", dependent: :destroy

  def all_relationships
    left_relationships + right_relationships
  end
end
