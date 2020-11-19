class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.integer :quantity
      t.bigint :product_id
      t.bigint :order_id

      t.timestamps
    end
  end
end
