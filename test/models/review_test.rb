require "test_helper"

describe Review do
  let(:review) {
    Review.new(rating: 5,
                            text_review: "Trip was great!",
                            product_id: products(:hawaii).id,
                            user_id: users(:jasmine).id) }

  it "can be instantiated" do
    expect(review.valid?).must_equal true
  end

  describe "validations" do
    it 'is valid when all fields are present' do
      result = review.valid?
      expect(result).must_equal true
    end

    it 'is valid with a rating greater than zero, and no text review' do
      review.text_review = nil
      result = review.valid?

      expect(result).must_equal true
    end

    it "is invalid with a rating less than zero" do
      review.rating = -5
      result = review.valid?

      expect(result).must_equal false
    end

    it "is invalid with a rating greater than 5" do
      review.rating = 6
      result = review.valid?

      expect(result).must_equal false
    end

    it "is invalid with no rating" do
      review.rating = nil
      result = review.valid?

      expect(result).must_equal false
    end
  end

  describe "relations" do
    it "belongs to product" do
      result = review.product

      expect(result).must_equal products(:hawaii)
    end

    it "is invalid without a product id" do
      review.product_id = nil
      result = review.valid?

      expect(result).must_equal false
    end
    it "belongs to user" do
      result = review.user

      expect(result).must_equal users(:jasmine)
    end

    it "is invalid without a user id" do
      review.user_id = nil
      result = review.valid?

      expect(result).must_equal false
    end
  end

end
