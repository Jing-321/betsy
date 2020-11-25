require "test_helper"

describe OrderItemsController do
  before do
    @fake_item_params = {quantity: 2, product_id: products(:japan).id, order_id: orders(:order1)}
    @new_params = {quantity: 3, product_id: products(:disney).id, order_id: orders(:order1)}
  end

  describe "new" do
    it 'can be instantiated' do
      test_order_item = OrderItem.new(@new_params)
      expect(test_order_item).must_be_kind_of OrderItem
    end
  end

  describe "create" do
    it "can add new order item as guest" do
      new_order_item = OrderItem.create(@fake_item_params)
      expect(new_order_item).must_be_kind_of OrderItem

    end

    it"adds new order item to current order" do
      # fake_order_item = OrderItem.create(quantity: )

    end

    it "responds with :error when quantity is lower than stock" do

    end

    it "will respond with not found when product_id is invalid" do

    end
  end


  describe "destroy" do
    # before do
    #   fake_item_params = {product_id: products(:fake_trip).id, quantity: 2}
    #   post order_items_path, params: fake_item_params
    #
    #   @current_order = Order.find_by(id: session[:order_id])
    #   @current_item = @current_order.order_items.first
    # end

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
