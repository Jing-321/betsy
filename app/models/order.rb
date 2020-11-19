class Order < ApplicationRecord
  belongs_to :user
  has_many :order_item

  validates :user_id, presence: true
  validates :status, presence: true, inclusion: {in: ["pending", "completed"]}
  validates :card_number, presence: true, if: :paid_with_card?

  # def paid_with_card?
  #   payment_type == "card"
  # end

end
