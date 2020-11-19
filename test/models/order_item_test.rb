require "test_helper"

describe OrderItem do
  let(:order_item) { order_items(:one) }

  it "can be instantiated" do
    expect(order_item.valid?).must_equal true
  end

  describe "validations" do
    it 'is valid when all fields are present' do
      order_item = order_items(:one)
      result = order_item.valid?

      expect(result).must_equal true
    end

    it 'is valid with a quantity greater than zero' do
      order_item = order_items(:one)
      result = order_item.valid?
      expect(result).must_equal true
    end

    it 'is invalid with a quantity that is not an integer' do
      order_item = order_items(:one)
      order_item.quantity = 1.5
      result = order_item.valid?
      expect(result).must_equal false
    end
  end

  describe "relationships" do
    it "belongs to product" do

    end

    it "belongs to order" do

    end
  end
end

