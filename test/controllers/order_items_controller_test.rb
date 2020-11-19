require "test_helper"

describe OrderItemsController do

  describe "create" do
    it"adds new order item to current order" do

    end

    it "responds with :error when quantity is lower than stock" do

    end

    it "will respond with not found when product_id is invalid" do

    end
  end

  describe "destroy" do
    before do
      fake_item_params = {product_id: products(:fake_trip).id, quantity: 2}
      post order_items_path, params: fake_item_params

      @current_order = Order.find_by(id: session[:order_id])
      @current_item = @current_order.order_items.first
    end

    it "deletes an order item with valid input" do

    end

    it "does not delete an order item if order.status != session[:order_id]" do

    end

    it "responds :unauthorized when order.status != pending" do

    end

    it "responds :bad_request when asked to delete an order item when order_item.id is invalid" do

    end

    it "responds :bad_request when order.id is invalid" do

    end
  end
end
