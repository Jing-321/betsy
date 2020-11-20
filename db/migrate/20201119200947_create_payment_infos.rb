class CreatePaymentInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_infos do |t|
      t.string :email
      t.string :address
      t.string :credit_card_name
      t.integer :credit_card_number
      t.string :credit_card_exp
      t.integer :credit_card_CVV
      t.integer :zip_code

      t.timestamps
    end
  end
end
