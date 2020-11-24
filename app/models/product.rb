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

  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_and_belongs_to_many :categories


  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true

  def avg_rating
    all_ratings = reviews.map { |review| review.rating }
    return nil if all_ratings.empty?

    average = all_ratings.sum / all_ratings.length.to_f
    return average.round
  end

  def switch_status
    if self.active
      return self.update(active: false)
    else
      return self.update(active: true)
    end
  end


  def self.get_top_rated

    products = Product.where(active: true)
    products_no_reviews = products.select { |p| p.avg_rating.nil? }
    products_with_reviews = products - products_no_reviews
    top_rated = products_with_reviews.sort  { |p| p.avg_rating }.reverse! + products_no_reviews
        
    # if top_rated.count < 4
    #   (4 - top_rated.count).times do |i|
    #     top_rated << products_no_reviews[i]
    #   end
    # end

    return top_rated.first(4)
  end

end
