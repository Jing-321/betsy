class Order < ApplicationRecord
  belongs_to :user
  has_many :order_item

  validates :user, presence: true
  validates :status, presence: true, inclusion: {in: ["open", "completed"]}
end
