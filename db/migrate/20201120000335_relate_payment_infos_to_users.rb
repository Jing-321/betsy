class RelatePaymentInfosToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :payment_infos, :user, index:true
  end
end
