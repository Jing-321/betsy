require 'test_helper'

describe Order do
  it 'is can be instantiated' do

  end

  describe 'validations' do
    it 'is valid with all fields' do

    end

    it 'must have a user_id' do

    end

    it 'is invalid if user_id is missing' do

    end

    it "is valid when status is 'pending'" do

    end

    it "is valid when status is 'complete'" do

    end

    it "is invalid when status is not 'pending' or 'complete'" do

    end
  end

  describe 'relationships' do
    it"belongs to a user" do

    end

    it "can have many order_items" do

    end

    it "can belong to payment_info" do

    end
  end

  describe 'custom methods' do
    describe "total price" do
      it "can compute total_price accurately" do

      end

      it "returns 0 if the order doesn't exit" do

      end

      it "returns 0 if there are no order items" do

      end
    end

    describe "current quantity" do
      it "will return the current quantity of an order_item if it exists in the order" do

      end

      it "will return 0 if an order_item doesn't exist in the order" do

      end
    end

    describe "confirm order items" do
      it "returns true if order_item matches product id" do

      end

      it "increases quantity of item if order_item matches product id" do

      end

      it "returns false if there are no order_items in the cart" do

      end
    end


  end
end
