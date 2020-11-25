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

    end

    it "has many order_items" do

    end

    it "has many reviews" do

    end

    it "has many categories" do

    end

    it "belongs to many categories" do

    end
  end

  describe "Custom Methods" do
    describe "avg rating" do
      it "returns nil if there are no ratings" do

      end

      it "returns the average of a number of ratings" do

      end
    end

    describe "retire" do
      it "will change active to true, if currently false" do

      end

      it "will change active to false, if currently true" do

      end
    end

    describe "get top rated" do

    end
  end
end
