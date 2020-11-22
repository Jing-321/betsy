class RemoveColumnFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :status
  end
end
