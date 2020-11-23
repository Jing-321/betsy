require "test_helper"

describe Product do
  it "can be instantiated" do

  end

  it "will have the required fields" do

  end
  describe "Validations" do
    it "must have a name" do

    end
    it "must have a description" do

    end

    it "must have a price" do

    end

    it "must have a price that is greater than 0" do

    end

    it "must have a price that is only an integer" do

    end

    it "must have stock" do

    end

    it "it must have a stock greater than 0" do

    end

    it "must have a user_id" do

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
