class ProjectInstance < ActiveRecord::Base
  belongs_to :project
  has_many :installations

  has_many :comments, as: :commentable

  validates :project_id, presence: true

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |project_instance|
        csv << project_instance.attributes.values_at(*column_names)
      end
    end
  end
end
