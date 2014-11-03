# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string(255)
#  uid                    :string(255)
#  github                 :string(255)
#  token                  :string(255)
#  suspended              :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable, 
    :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable

  #include PgSearch
  #multisearchable against: :github

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.github = auth.info.nickname
    end
  end

  def is_dev_team?
    # Checks with github to see if the user is a member of the unepwcmc wcmc-core-devs team. If so, sets is_unep to true
    # so that the API is only hit once on login, else set to false and login denied.
    response = HTTParty.get("https://api.github.com/teams/98845/memberships/#{self.github}?access_token=#{self.token}", headers: {"User-Agent" => "Labs"})
    response_hash = JSON.parse(response.body)
    response_hash.has_key?("state") and response_hash["state"] == "active"
  end

  def set_token(auth)
    self.token = auth.credentials.token
    self.save!
  end

  def suspend
    self.suspended = true
    self.save!
  end

  def active_for_authentication?
    super && !self.suspended?
  end

  def inactive_message
    !self.suspended? ? super : :suspended
  end
end
