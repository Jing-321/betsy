class RelateOrdersToPaymentInfos < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :payment_info, index: true
  end
end
