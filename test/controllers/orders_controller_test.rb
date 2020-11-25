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

    it "will redirect to homepage for invalid ids" do
      get "/orders/1234"
      must_redirect_to root_path
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
      @order = orders(:order1)
      perform_login
    end

    it "will change order status from pending to complete" do
      get order_submit_path(@order.id)
      expect(@order.status).must_equal "complete"
    end

    it "will lower the product stock" do
      @product = products(:japan)
      OrderItem.create(quantity: 1, product_id: @product.id, order_id: @order.id)


      expect{
        get order_submit_path(@order.id)
      }.must_differ '@product.stock', 1

    end
  end
end
