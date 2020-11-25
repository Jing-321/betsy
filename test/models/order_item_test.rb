require "test_helper"

describe OrderItem do

  let(:order_item) {order_items(:one)}

  it "can be instantiated" do
    expect(order_item.valid?).must_equal true
  end

  describe "validations" do
    it 'is valid when required fields are present' do
      order_item = order_items(:one)
      result = order_item.valid?
      expect(result).must_equal true
    end

    it 'is invalid with a quantity equal or less than zero' do
      order_item = order_items(:one)
      order_item.quantity = 0
      result = order_item.valid?
      expect(result).must_equal false
    end

    it 'is valid with a quantity greater than zero' do
      order_item = order_items(:one)
      result = order_item.valid?
      expect(result).must_equal true
    end

    it 'is invalid with a quantity that is not an integer' do
      order_item = order_items(:one)
      order_item.quantity = "Kaida is awesome"
      result = order_item.valid?
      expect(result).must_equal false
    end

    it 'must have a quantity' do
      order_item = order_items(:one)
      order_item.quantity = nil
      result = order_item.valid?
      expect(result).must_equal false
    end

    it 'must have a product_id' do
      order_item = order_items(:one)
      order_item.product_id = nil
      result = order_item.valid?
      expect(result).must_equal false
    end

    it "cannot create an order_item with quantity = 0" do
      order_item = order_items(:one)
      order_item.quantity = 0
      result = order_item.valid?
      expect(result).must_equal false
    end
  end


  describe "relations" do
    it "belongs to product" do
      one = order_items(:one)
      _(one).must_respond_to :product
      _(one.product).must_be_kind_of Product
    end

    it "belongs to order" do
      one = order_items(:one)
      _(one).must_respond_to :order
      _(one.order).must_be_kind_of Order
    end
  end
end



