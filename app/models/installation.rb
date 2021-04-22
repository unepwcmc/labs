# == Schema Information
#
# Table name: installations
#
#  id                  :integer          not null, primary key
#  server_id           :integer          not null
#  role                :string(255)      not null
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  product_instance_id :integer          not null
#  deleted_at          :datetime
#  closing             :boolean          default(FALSE)
#

class Installation <  ApplicationRecord
  acts_as_paranoid

  belongs_to :server
  belongs_to :product_instance
  has_many :comments, as: :commentable

  #Validations
  validates :server_id, :role, presence: true
  validates :role, inclusion: { in: ['Web', 'Database', 'Web & Database']}

  delegate :stage, to: :product_instance
  delegate :product, to: :product_instance

  after_create { product.refresh_reviews }
  after_destroy { product.refresh_reviews }

  def name
    "#{self.product.title} - #{role} (#{stage})"
  end

  def product_instance
    ProductInstance.unscoped { super }
  end

  def server
    Server.unscoped { super }
  end

end
