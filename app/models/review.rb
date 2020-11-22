class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
  validates :text_review, length: { maximum: 140, too_long: '%{count} characters is the maximum allowed' }

end

