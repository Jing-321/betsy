require "test_helper"

describe OrderItemsController do
  describe "destroy" do
    before do
      @order_item = order_items(:two)
    end

    it "deletes an order item with valid input" do
      expect{
        delete order_item_path(@order_item.id)
      }.must_differ "OrderItem.count", -1

      expect(flash[:result_text]).must_include "#{@order_item.product.name} removed from cart."

      must_redirect_to root_path
    end
  end

  describe "increase_qty" do
    it "increases product quantity when product is in the cart" do
      fake_order_item = {
          quantity: 2,
          product_id: products(:japan).id,
          order_id: orders(:order1).id
      }

      expect {
          patch add_path(products(:japan).id), params: fake_order_item
      }.wont_differ 'OrderItem.count'

      must_redirect_to shopping_cart_path
    end

    it "won't increase product quantity when asking for more items than stock quantity" do
      fake_order_item = {
          quantity: 5,
          product_id: products(:disney).id,
          order_id: orders(:order1).id
      }

      expect {
        patch add_path(products(:disney).id), params: fake_order_item
      }.wont_differ 'OrderItem.count'

      must_redirect_to shopping_cart_path
    end
  end

  describe "decrease_qty" do
    it "decreases amount of item when in cart" do
      fake_order_item2 = {
          quantity: 2,
          product_id: products(:japan).id,
          order_id: orders(:order1).id
      }

      expect {
        patch subtract_path(products(:japan).id), params: fake_order_item2
      }.wont_differ 'OrderItem.count'

      must_redirect_to shopping_cart_path
    end

    it "removes product from cart when product quantity in cart is <= 1" do
      fake_order_item3 = {
          quantity: 1,
          product_id: products(:japan).id,
          order_id: orders(:order1).id
      }

      expect {
        patch subtract_path(products(:japan).id), params: fake_order_item3
      }.wont_differ 'OrderItem.count'

      must_redirect_to shopping_cart_path
    end
  end
end
