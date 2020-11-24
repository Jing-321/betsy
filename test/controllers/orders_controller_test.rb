require "test_helper"

describe OrdersController do
  describe "show" do
    before do
      @order = Order.first
    end

    it "will get show for valid ids" do
      get "/orders/#{@order.id}"
      must_respond_with :success
    end

    it "will respond with "

  end
end
