class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  belongs_to :payment_info, optional: true

  validates :user_id, presence: true
  validates :status, presence: true, inclusion: {in: ["pending", "complete"]}
  # validates :payment_info, allow_nil: true, allow_blank: true


  def total_price
    total = 0
    if self.nil? || self.order_items.empty?
    else
      items = Order.find(self.id).order_items
      if items.length > 0
        items.each do |item|
          total += Product.find(item.product_id).price * item.quantity
        end
      end
    end


    return total
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
