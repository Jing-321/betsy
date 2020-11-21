class RelateReviewsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :reviews, :user, index: true
  end
end
