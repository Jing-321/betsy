class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  belongs_to :payment_info

  validates :user_id, presence: true
  validates :status, presence: true, inclusion: {in: ["pending", "completed"]}


  def cart_total

  end

  def credit_card_info

  end
end
