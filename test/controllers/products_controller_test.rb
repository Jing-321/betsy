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
      # todo: get product id
      get products_path(product)
      must_respond_with :success
    end

    it "will respond with not_found for invalid id" do
      get products_path(-1)
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "can get new form" do
      get new_products_path
      must_respond_with :success
    end
  end

  describe "create" do
    let (:new_params) {
      {
        product: {
          name: "test_name",
          price: 15.00,
          description: "test description"
        }
      }
    }
    it "successfully creates product with all valid inputs" do
      expect {
        post products_path, params: new_params
      }.must_differ "Product.count", 1

      product = Product.find_by(name: "test_name")
      must_respond_with :redirect
      must_redirect_to product_path(product)
      # todo include flash message?

      # todo verify price is formatted correctly
      expect(product.name).must_equal new_params[:product][:name]
      expect(product.price).must_equal new_params[:product][:price]
      expect(product.description).must_equal new_params[:product][:description]
    end

    it "won't create product if params are invalid" do
      new_params[:product][:name] = nil
      expect {
        post products_path, params: new_params
      }. wont_differ 'Product.count', 1

      # todo include flash message?
      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "can get edit form" do

      #todo get the product id
      get edit_product_path(product)
      must_respond_with :success
    end

    it "will return :not_found if id doesn't exist" do
      get edit_product_path(-1)
      must_respond_with :not_found
    end
  end

  describe "update" do
    let (:update_params) {
      {
        product: {
          name: "test update",
          price: 12.00,
          description: "updated test description"
        }
      }
    }
    it "it will update product with a valid post request" do
      #todo get product id, product = ??
      expect {
        post product_path(product), params: update_params
      }.wont_differ "Product.count"

      product.reload
      must_respond_with :redirect
      must_redirect_to product_path(product)
      # todo include flash message?

      # todo verify price is formatted correctly
      expect(product.name).must_equal update_params[:product][:name]
      expect(product.price).must_equal update_params[:product][:price]
      expect(product.description).must_equal update_params[:product][:description]
    end

    it "won't update product with invalid params" do
      update_hash[:product][name] = nil

      #todo get product id, product = ??
      expect {
        patch product_path(product), params: update_hash
      }.wont_differ "Product.count"

      must_respond_with :bad_request
      #todo include flash message?
    end

    it "will return not_found when given and invalid id" do
      expect {
        patch product_path(-1), params: update_hash
      }.wont_differ "Product.count"

      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "successfully deletes product, redirect to index and reduces count by 1" do
      #todo get product id
      expect {
        delete product_path(product)
      }.must_differ "Product.count", -1

      must_respond_with :redirect
      must_redirect_to products_path
      # todo include flash message
    end

    it "will return not_found with invalid id" do
      expect {
        delete product_path(-1)
      }.wont_differ "Product.count"

      must_respond_with :not_found
    end
  end
end
