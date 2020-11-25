require "test_helper"

describe OrderItem do
  #quantity, product_id, order_id
  before do
    fake_order_item = OrderItem.new(
        quantity: 2,
        product_id: 22,
        order_id: 15
    )
    fake_order_item.save
  end

  it "can be instantiated" do
    expect(fake_order_item.valid?).must_equal true
  end

  describe "validations" do
    it 'is valid when required fields are present' do
      fake_order_item.save!
      fake_item = OrderItem.find_by(name: :fake_order_item)

      [:quantity, :product_id].each do |field|
        expect(fake_item).must_respond_to field
      end
    end

    it 'is valid with a quantity is greater than zero' do
      fake_order_item.quantity = -2
      expect(fake_order_id.valid?).must_equal false
    end

    it 'is invalid with a quantity that is not an integer' do
      fake_order_item.quantity = "Kaida is awesome"
      expect(fake_order_item.valid?).must_equal false
    end

    it 'must have a quantity' do
      fake_order_item.quantity = nil
      expect(fake_order_item.valid?).must_equal false
      expect(fake_order_item.errors.messages).must_include :quantity
    end

    it 'must have a product_id' do
      fake_order_item.product_id = nil
      expect(fake_order_item.valid?).must_equal false
      expect(fake_order_item.errors.messages).must_include :product_id
    end

    it "cannot create an order_item with quantity = 0" do
      fake_order_item.quantity = 0
      expect(fake_order_item.valid?).must_equal false
      expect(fake_order_item.errors.messages).must_include :quantity
      expect(fake_order_item.errors.messages[:quantity]).must_include "must be greater than 0"
    end
  end


  describe "relationships" do
    # before do
    #   fake_ord = OrderItem.new(
    #       quantity: 3,
    #       product_id: 22,
    #       order_id: 15
    #   )
    # end

    it "belongs to product" do
      # fake_order_item.save!
      #
      # expect(fake_order_item[:product_id]).must_be 22

    end

    it "belongs to order" do
      # fake_order_item.save!
      #
      # expect(fake_order_item[:product_id]).must_be 15
    end
  end
end



