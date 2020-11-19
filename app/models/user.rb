class User < ApplicationRecord
  # id (default)
  # username (logged in user)
  # email (logged in user)
  # order_id (create a relation migration between order and users)


  has_many :orders
  has_many :products, dependent: :destroy
  has_many :reviews



  validates :username, presence: true
  validates :email, confirmation: true

end
