class Order < ApplicationRecord
  belongs_to :user
  has_many :order_item

  validates :user_id, presence: true
  validates :status, presence: true, inclusion: {in: ["open", "completed"]}


  def cart_total

  end
end
