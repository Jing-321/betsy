require "test_helper"

# "rating"
# "text_review"

describe ReviewsController do
  let (:new_params) {
    {
      review: {
        rating: 4,
        text_review: "This trip was exceptiona!"
      }
    }
  }
  describe "new" do
    it "can get new form" do
      get new_review_path
      must_respond_with :success
    end
  end
  describe "create" do
    it "successfully creates a review with all valid inputs" do
      expect {
        post product_reviews_path(products(:hawaii).id), params: new_params
      }.must_differ "Review.count", 1

      review = Review.find_by(rating: 4)
      must_respond_with :redirect
      must_redirect_to review_path(review)
      expect(flash[:success]).must_include new_params[:review][:rating]

      expect(review.rating).must_equal new_params[:review][:rating]
      expect(review.text_review).must_equal new_params[:review][:text_review]
    end
  end

  it "won't create a review if params are invalid" do
    new_params[:review][:rating] = nil
    expect {
      post product_reviews_path(products(:hawaii).id), params: new_params
    }. wont_differ 'Review.count', 0

    expect(flash.now[:error]).must_include "Something happened, could not create a review"
    must_respond_with :bad_request
  end
end
