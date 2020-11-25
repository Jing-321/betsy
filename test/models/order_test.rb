require 'test_helper'

describe Order do
  let(:order) {
    Order.new(user_id: users(:jasmine).id,
    status: "pending")
  }
  it 'can be instantiated' do
    expect(order.valid?).must_equal true
  end

  describe 'validations' do
    it 'is valid with all fields' do
      result = order.valid?
      expect(result).must_equal true
    end

    it 'must have a user_id' do
      order.user_id = nil
      expect(order.valid?).must_equal false
    end

    it "is valid when status is 'pending'" do
      order.status = 'pending'
      expect(order.valid?).must_equal true
    end

    it "is valid when status is 'complete'" do
      order.status = 'complete'
      expect(order.valid?).must_equal true
    end

    it "is invalid when status is not 'pending' or 'complete'" do
      order.status = 'delivered'
      expect(order.valid?).must_equal false
    end
  end

  describe 'relationships' do
    it"belongs to a user" do
      expect(order.user).must_equal users(:jasmine)
    end

    it "can have many order_items" do
      order.save!
      order_item1 = OrderItem.create(quantity: 5, product_id: products(:hawaii).id, order_id: order.id)
      order_item2 = OrderItem.create(quantity: 5, product_id: products(:disney).id, order_id: order.id)

      expect(order.order_items.count).must_equal 2
      expect(order.order_items).must_include order_item1
      expect(order.order_items).must_include order_item2
    end

    it "can belong to payment_info" do
      order.save!
      user = users(:jasmine)
      payment = PaymentInfo.create!(
          email: 'abc@email.com',
          address: '123 St. USA',
          credit_card_name: 'Jane Doe',
          credit_card_number: 123456789,
          credit_card_exp: '12/12',
          credit_card_CVV: 123,
          zip_code: '456789',
          user_id: user.id)
      order.payment_info_id = payment.id
      order.save!

      expect(order.payment_info_id).must_equal payment.id
      expect(payment.orders).must_include order
    end
  end

  describe 'custom methods' do
    describe "total price" do
      it "can compute total_price accurately" do

        order.save!

        hawaii = products(:hawaii)
        japan = products(:japan)

        order_item1 = OrderItem.create(quantity: 1, product_id: hawaii.id, order_id: order.id)
        order_item2 = OrderItem.create(quantity: 1, product_id: japan.id, order_id: order.id)

        expect(order.total_price).must_equal 25

      end

      # it "returns 0 if the order doesn't exit" do
      #   # order = nil
      #   expect(order.total_price).must_equal 0
      # end

      it "returns 0 if there are no order items" do
        order.save!
        expect(order.total_price).must_equal 0
      end
    end

    describe "current quantity" do
      it "will return the current quantity of an order_item if it exists in the order" do
        order.save!
        hawaii = products(:hawaii)
        order_item1 = OrderItem.create(quantity: 1, product_id: hawaii.id, order_id: order.id)
        expect(order.current_quantity(hawaii.id)).must_equal 1
      end

      it "will return 0 if an order_item doesn't exist in the order" do
        order.save!
        product = products(:japan)
        expect(order.current_quantity(product.id)).must_equal 0
      end
    end

    describe "confirm order items" do
      it "returns true if order_item matches product id" do
        order.save!
        hawaii = products(:hawaii)
        order_item1 = OrderItem.create(quantity: 1, product_id: hawaii.id, order_id: order.id)
        expect(order.confirm_order_items(hawaii.id, 1)).must_equal true
      end

      it "increases quantity of item if order_item matches product id" do
        order.save!
        hawaii = products(:hawaii)
        OrderItem.create(quantity: 1, product_id: hawaii.id, order_id: order.id)
        order.confirm_order_items(hawaii.id, 5)
        expect(order.order_items.first.quantity).must_equal 6
      end

      it "returns false if there are no order_items in the cart" do
        order.save!
        hawaii = products(:hawaii)
        expect(order.confirm_order_items(hawaii.id, 1)).must_equal false
      end
    end
  end
end
