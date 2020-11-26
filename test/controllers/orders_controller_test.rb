require "test_helper"

describe OrdersController do

  describe "show" do
    before do
      @order = Order.first
      perform_login
    end

    it "will get show for valid ids" do
      get "/orders/#{@order.id}"
      must_respond_with :success
    end

    it "will respond with not_found for invalid ids" do
      get order_path(1234)
      must_respond_with :not_found
    end

  end

  describe "shopping_cart" do

    it "respond with success when user is not logged in" do
      get shopping_cart_path
      must_respond_with :success
    end

    it "respond with success when user is logged in" do
      perform_login
      get shopping_cart_path
      must_respond_with :success
    end
  end

  describe "submit" do
    before do
      perform_login
      @order = add_first_item_to_cart
    end

    it "will change order status from pending to complete" do
      expect(@order.status).must_equal "pending"
      get order_submit_path(@order.id)
      @order.reload
      expect(@order.status).must_equal "complete"
    end

    it "will lower the product stock" do
      @product = @order.order_items.first.product
      stock = @product.stock

      get order_submit_path
      @product.reload
      expect(@product.stock).must_equal stock-1

    end
  end
end
