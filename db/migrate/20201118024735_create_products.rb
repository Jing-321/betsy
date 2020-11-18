class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.integer :stock
      t.integer :order_item_id
      t.integer :review_id
      t.integer :category_id
      t.timestamps
    end
  end
end
