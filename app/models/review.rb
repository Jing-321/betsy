class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user

  # rating
  # text_review

  validates :rating, presence: true, numericality: { only_integer: true, greater_than: 0}
  validates :text_review, length: { maximum: 100, too_long: '%{count} characters is the maximum allowed' }
end

