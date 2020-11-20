class Order < ApplicationRecord
  belongs_to :user
  has_many :order_item

  validates :user_id, presence: true
  validates :status, presence: true, inclusion: {in: ["pending", "completed"]}


  def cart_total

  end

  def credit_card_info

  end

  def current_qty(item_id)
    if self.order_items.any?
      self.order_items.each do |current_item|
        if current_item.product.id == item_id
          return current_item.quantity.to_i
        end
      end
    end
    return 0
  end

end
