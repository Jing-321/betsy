require "test_helper"

describe ProductsController do
  describe "index" do
    it "can get index" do

      get products_path
      must_respond_with :success

    end
  end

  describe "show" do
    it "can get show page" do

      product = products(:hawaii)
      get product_path(product)
      must_respond_with :success
    end

    it "will respond with not_found for invalid id" do
      get product_path(-1)

      expect(flash[:error]).must_equal "Tour not found"

      must_redirect_to products_path
    end
  end

  describe "new" do
    it "can get new form when logged in" do
      perform_login

      get new_product_path
      must_respond_with :success
    end

    it "cannot get new form when not logged in" do
      get new_product_path
      expect(flash[:error]).must_include "not authorized"
      must_respond_with :redirect
    end
  end

  describe "create" do
    let (:new_params) {
      {
        product: {
          name: "test_name",
          price: 15,
          description: "test description",
          stock: 2
        }
      }
    }
    it "successfully creates product with all valid inputs" do
      perform_login

      expect {
        post products_path, params: new_params
      }.must_differ "Product.count", 1

      product = Product.find_by(name: "test_name")
      must_respond_with :redirect
      must_redirect_to product_path(product)
      expect(flash[:success]).must_include new_params[:product][:name]

      expect(product.name).must_equal new_params[:product][:name]
      expect(product.price).must_equal new_params[:product][:price]
      expect(product.description).must_equal new_params[:product][:description]
      expect(product.stock).must_equal new_params[:product][:stock]
    end

    it "won't create product if params are invalid" do
      new_params[:product][:name] = nil
      expect {
        post products_path, params: new_params
      }. wont_differ 'Product.count', 1

      expect(flash.now[:error]).must_include "Something happened, could not create tour"
      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "can get edit form" do

      product = products(:hawaii)
      user = product.user
      perform_login(user)

      get edit_product_path(product)
      must_respond_with :success
    end

    it "will redirect if id doesn't exist" do
      perform_login
      get edit_product_path(-1)
      must_redirect_to products_path
    end
  end

  describe "update" do
    let (:update_params) {
      {
        product: {
          name: "test update",
          price: 12,
          description: "updated test description",
          stock: 25
        }
      }
    }
    it "it will update product with a valid post request" do


      product = products(:hawaii)
      user = product.user
      perform_login(user)

      expect {
        patch product_path(product), params: update_params
      }.wont_differ "Product.count"

      product.reload
      must_respond_with :redirect
      must_redirect_to product_path(product)
      expect(flash[:success]).must_include "Successfully updated"

      expect(product.name).must_equal update_params[:product][:name]
      expect(product.price).must_equal update_params[:product][:price]
      expect(product.description).must_equal update_params[:product][:description]
      expect(product.stock).must_equal update_params[:product][:stock]
    end

    it "won't update product with invalid params" do
      update_params[:product][:name] = nil

      product = products(:japan)
      user = product.user
      perform_login(user)
      expect {
        patch product_path(product), params: update_params
      }.wont_differ "Product.count"

      must_respond_with :bad_request
      expect(flash.now[:error]).must_include "Something is wrong. Could not update tour"
    end

    it "will return not_found when given and invalid id" do
      expect {
        patch product_path(-1), params: update_params
      }.wont_differ "Product.count"

      must_redirect_to products_path
      expect(flash[:error]).must_equal "Tour not found"
    end
  end

  describe "add to cart" do

    it "returns not found if the product doesn't exist" do
      post add_to_cart_path(-1)
      must_respond_with :not_found
    end

    it "will create a user for a quest when no one is logged in" do
      hawaii = products(:hawaii)
      expect {
        post add_to_cart_path(hawaii)
      }.must_differ "User.count", 1

      guest = User.find_by(id: session[:user_id])
      expect(guest).wont_be_nil

      expect(session[:user_id]).must_equal guest.id
    end

    it "creates a new order if one does not exist with status pending" do

      perform_login

      hawaii = products(:hawaii)
      expect {
        post add_to_cart_path(hawaii)
      }.must_differ "Order.count", 1

      merchant = User.find_by(id: session[:user_id])
      order = Order.find_by(id: session[:order_id])
      expect(order.user_id).must_equal merchant.id
      expect(order.status).must_equal "pending"

    end

    it "creates an order_item if with the creation of an order" do
      perform_login

      hawaii = products(:hawaii)
      post add_to_cart_path(hawaii)

      order = Order.find_by(id: session[:order_id])
      order_item = order.order_items.first
      expect(order_item.quantity).must_equal 1
      expect(order_item.product_id).must_equal hawaii.id
      expect(order_item.order_id).must_equal order.id
    end

    it "redirects to the shopping cart when the first product is added to the cart" do
      hawaii = products(:hawaii)
      post add_to_cart_path(hawaii)
      expect(flash[:success]).must_include "added to your cart"
      must_respond_with :redirect
      must_redirect_to shopping_cart_path
    end

    it "creates an order item if there are no order items but an order already exists & redirects to cart" do

    end

    it "it will increase the quantity by one if the same product exists in the cart and redirect" do

    end

    it "will redirect & show message if a user tries to add a product that is out of stock" do

    end

    it "will create an order_item if the associated product is not in the cart & the cart has order items & redirect" do

    end
  end

  describe "retire" do
    it "will change a products status to false if true" do
      hawaii = products(:hawaii)
      p hawaii.active
        post retire_path(hawaii)
      p hawaii.active


    end

    it "will change a products status to true if false" do

    end
  end

  describe "explore" do
    it "returns success when it gets explore" do
      get explore_path
      must_respond_with :success
    end
  end

  describe "check_authorization" do
    it "will prevent a guest user from editing a tour" do
      hawaii = products(:hawaii)
      get edit_product_path(hawaii)
      expect(flash.now[:error] ).must_equal "You are not authorized to view this page."
      must_respond_with :unauthorized
    end
  end

  # describe "destroy" do
  #   it "successfully deletes product, redirect to index and reduces count by 1" do
  #     product = products(:taiwan)
  #     user = product.user
  #     perform_login(user)
  #     expect {
  #       delete product_path(product)
  #     }.must_differ "Product.count", -1
  #
  #     must_respond_with :redirect
  #     must_redirect_to products_path
  #     expect(flash[:success]).must_include "deleted"
  #   end
  #
  #   it "will return not_found with invalid id" do
  #     expect {
  #       delete product_path(-1)
  #     }.wont_differ "Product.count"
  #
  #     must_respond_with :redirect
  #     must_redirect_to products_path
  #     expect(flash[:error]).must_equal "Tour not found"
  #   end
  # end
end
