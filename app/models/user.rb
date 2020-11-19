class User < ApplicationRecord
  # id (default)
  # username (logged in user)
  # email (logged in user)
  # order_id (create a relation migration between order and users)


  has_many :orders
  has_many :products, dependent: :destroy



  validates :username, presence: true
  validates :email, confirmation: true


  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.username = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]
    return user
  end
end
