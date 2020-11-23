class PaymentInfo < ApplicationRecord
  validates :email, presence: true
  validates :address, presence: true
  validates :credit_card_name, presence: true
  validates :credit_card_number, presence: true,
            numericality: true
  validates :credit_card_exp, format: {with: /\d\d\/\d\d/, message: "Please use MM/YY format" }
  validates :credit_card_CVV, numericality: true
  validates :zip_code, format: {with: /\d{5}/, message: "Please enter your 5-digit zip code."}

  belongs_to :user
  has_many :orders

end
