class AddColumnsToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :photo_url, :string
    add_column :products, :status, :string
  end
end
