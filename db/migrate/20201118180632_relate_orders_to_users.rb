class RelateOrdersToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :user
    add_reference :orders, :user, index: true
  end
end
