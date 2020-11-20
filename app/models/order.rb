class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  belongs_to :payment_info

  validates :user_id, presence: true
  validates :status, presence: true, inclusion: {in: ["pending", "completed"]}


  def cart_total
    total = 0

  end

  def credit_card_info

  end

  def current_quantity(new_item)
    if self.order_items.any?
      self.order_items.each do |current_item|
        if current_item.product.id == new_item
          return current_item.quantity.to_i
        end
      end
    end
    return 0
  end

  def confirm_order_items(new_item, new_qty)
    if self.order_items.any?
      self.order_items.each do |item|
        if item.product.id.to_s == new_item.to_s
          item.quantity += new_qty.to_i
          item.save
          return true
        end
      end
    end
    return false
  end

end
