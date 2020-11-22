class Product < ApplicationRecord
  #id (default)
  # name
  # description
  # price
  # stock
  # img lower priority
  # order_item_id (relational migration)
  # review_id (relation migration) lower priority
  # category_id *lower priority

  has_many :order_items
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_and_belongs_to_many :categories


  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  def avg_rating
    all_ratings = reviews.map { |review| review.rating}
    return nil if all_ratings.empty?

    average = all_ratings.sum / all_ratings.length.to_f
    return average / 10 == 0 ? average : average.round(1)
  end

  def self.get_top_rated
    # use avg rating to get the top rated trips
    # if there no rated trips, sample a collection of them
  end

end
