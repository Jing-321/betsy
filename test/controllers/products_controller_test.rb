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
      get products_path(product)
      must_respond_with :success
    end

    it "will respond with not_found for invalid id" do
      get product_path(-1)

      expect(flash[:error]).must_equal "Tour not found"

      must_redirect_to products_path
    end
  end

  describe "new" do
    it "can get new form" do
      get new_product_path
      must_respond_with :success
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

    it "will return :not_found if id doesn't exist" do
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
    it "creates a new order if one does not exist" do

    end

    it ""
  end

  describe "retire" do

  end

  describe "explore" do

  end

  describe "find_product" do

  end

  describe "check_authorization" do

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
