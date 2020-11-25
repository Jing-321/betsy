require "test_helper"

describe Product do
  let(:new_tour) {
    Product.new(
      name: "New Tour",
      description: "Have a grand time!",
      price: 12,
      stock: 2,
      user_id: users(:jasmine).id
    )
  }
  it "can be instantiated" do
    expect(new_tour.valid?).must_equal true
  end

  it "will have the required fields" do
    new_tour.save!
    tour = Product.find_by(name: "New Tour")

    [:name, :description, :price, :stock, :user_id].each do |field|
      expect(tour).must_respond_to field
    end
  end
  describe "Validations" do
    it "must have a name" do
      new_tour.name = nil
      expect(new_tour.valid?).must_equal false
      expect(new_tour.errors.messages).must_include :name
      expect(new_tour.errors.messages[:name]).must_equal ["can't be blank"]

    end
    it "must have a description" do
      new_tour.description = nil
      expect(new_tour.valid?).must_equal false
      expect(new_tour.errors.messages).must_include :description
      expect(new_tour.errors.messages[:description]).must_equal ["can't be blank"]
    end

    it "must have a price" do
      new_tour.price = nil
      expect(new_tour.valid?).must_equal false
      expect(new_tour.errors.messages).must_include :price
      expect(new_tour.errors.messages[:price]).must_include "can't be blank"
    end

    it "must have a price that is greater than or equal to 0" do
      new_tour.price = -3
      expect(new_tour.valid?).must_equal false
      expect(new_tour.errors.messages).must_include :price
      expect(new_tour.errors.messages[:price]).must_include "must be greater than or equal to 0"
    end

    it "must be a number" do
      new_tour.price = "a"
      expect(new_tour.valid?).must_equal false
      expect(new_tour.errors.messages).must_include :price
      expect(new_tour.errors.messages[:price]).must_include "is not a number"
    end

    it "must have a price that is only an integer" do
      new_tour.price = 5.6
      expect(new_tour.valid?).must_equal false
      expect(new_tour.errors.messages).must_include :price
      expect(new_tour.errors.messages[:price]).must_include "must be an integer"
    end

    it "must have stock" do
      new_tour.stock = nil
      expect(new_tour.valid?).must_equal false
      expect(new_tour.errors.messages).must_include :stock
      expect(new_tour.errors.messages[:stock]).must_include "can't be blank"
    end

    it "it must be greater than or equal to" do
      new_tour.stock = -1
      expect(new_tour.valid?).must_equal false
      expect(new_tour.errors.messages).must_include :stock
      expect(new_tour.errors.messages[:stock]).must_include "must be greater than or equal to 0"
    end

    it "must have a user_id" do
      new_tour.user_id = nil
      expect(new_tour.valid?).must_equal false
      expect(new_tour.errors.messages).must_include :user_id
      expect(new_tour.errors.messages[:user_id]).must_include "can't be blank"
    end
  end

  describe "Relationships" do
    it "belongs to a user" do
      hawaii = products(:hawaii)
      expect(hawaii.user).must_equal users(:jasmine)
    end

    it "has many order_items" do

      hawaii = products(:hawaii)
      order1 = Order.create!(user_id: users(:jasmine).id, status: "pending")
      order_item1 = OrderItem.create!(quantity: 1, product_id: hawaii.id, order_id: order1.id)
      order_item2 = order_items(:one)

      expect(hawaii.order_items.count).must_equal 2
      expect(hawaii.order_items).must_include order_item1
      expect(hawaii.order_items).must_include order_item2
    end

    it "has many reviews" do
      hawaii = products(:hawaii)
      review1 = Review.create(rating: 5, text_review: "very good", product_id: hawaii.id)
      review2 = Review.create(rating: 3, text_review: "just okay", product_id: hawaii.id)

      expect(hawaii.reviews.count).must_equal 2
      expect(hawaii.reviews).must_include review1
      expect(hawaii.reviews).must_include review2
    end

    it "has many categories" do
      japan = products(:japan)
      expect(japan.categories.count).must_equal 3
      expect(japan.categories).must_include categories(:peaceful)
      expect(japan.categories).must_include categories(:romantic)
      expect(japan.categories).must_include categories(:fun)
    end

    it "belongs to many categories" do
      japan = products(:japan)
      peaceful = categories(:peaceful)
      romantic = categories(:romantic)
      fun = categories(:fun)

      expect(peaceful.products).must_include japan
      expect(romantic.products).must_include japan
      expect(fun.products).must_include japan

    end
  end

  describe "Custom Methods" do
    describe "avg rating" do
      it "returns nil if there are no ratings" do
        hawaii = products(:hawaii)
        expect(hawaii.avg_rating).must_be_nil
      end

      it "returns the average of a number of ratings rounded to the nearest whole number" do
        hawaii = products(:hawaii)

        review1 = Review.create(rating: 5, text_review: "very good", product_id: hawaii.id)
        review2 = Review.create(rating: 3, text_review: "just okay", product_id: hawaii.id)
        review2 = Review.create(rating: 4, text_review: "just okay", product_id: hawaii.id)

        expect(hawaii.avg_rating).must_equal 4
      end
    end

    describe "switch status" do
      it "will change active to true, if currently false" do
        hawaii = products(:hawaii)
        hawaii.active = false
        hawaii.save!

        hawaii.switch_status
        hawaii.reload
        expect(hawaii.active).must_equal true
      end

      it "will change active to false, if currently true" do
        hawaii = products(:hawaii)
        hawaii.active = true
        hawaii.save!

        hawaii.switch_status
        hawaii.reload
        expect(hawaii.active).must_equal false
      end
    end

    describe "get top rated" do
      it "gets the top 4 trips rated 4 stars or higher, if there are 4 trips with ratings height than 3 starts" do
        hawaii = products(:hawaii)
        hawaii.active = true
        hawaii.save
        Review.create(rating: 5, text_review: "very good", product_id: hawaii.id)
        japan = products(:japan)
        japan.active = true
        japan.save
        Review.create(rating: 5, text_review: "very good", product_id: japan.id)
        taiwan = products(:taiwan)
        taiwan.active = true
        taiwan.save
        Review.create(rating: 4, text_review: "very good", product_id: taiwan.id)
        disney = products(:disney)
        disney.active = true
        disney.save
        Review.create(rating: 2, text_review: "very bad", product_id: disney.id)
        lahore = products(:lahore)
        lahore.active = true
        lahore.save
        Review.create(rating: 4, text_review: "very good", product_id: lahore.id)

        top_rated = Product.get_top_rated
        expect(top_rated.count).must_equal 4
        expect(top_rated).must_include hawaii
        expect(top_rated).must_include japan
        expect(top_rated).must_include taiwan
        expect(top_rated).must_include lahore

      end

      it "gets the trips with 4 stars or higher or with an avg rating of nil" do
        hawaii = products(:hawaii)
        hawaii.active = true
        hawaii.save
        Review.create(rating: 5, text_review: "very good", product_id: hawaii.id)
        japan = products(:japan)
        japan.active = true
        japan.save
        Review.create(rating: 5, text_review: "very good", product_id: japan.id)
        taiwan = products(:taiwan)
        taiwan.active = true
        taiwan.save
        Review.create(rating: 1, text_review: "bad", product_id: taiwan.id)
        disney = products(:disney)
        disney.active = true
        disney.save
        lahore = products(:lahore)
        lahore.active = true
        lahore.save

        top_rated = Product.get_top_rated
        expect(top_rated.count).must_equal 4
        expect(top_rated).must_include hawaii
        expect(top_rated).must_include japan
        expect(top_rated).must_include disney
        expect(top_rated).must_include lahore
      end
    end
  end
end
