require "test_helper"

describe CategoriesController do
  describe "index" do
    it "responds with success when getting index" do
      get categories_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success with a valid id" do
      fun = categories(:fun)
      get category_path(fun)
      must_respond_with :success
    end

    it "returns not found with an invalid id" do
      get category_path(-1)
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success when getting new form" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "create" do
    let(:new_category) {
      {
        category: {
          name: "test name"
        }
      }
    }
    it "successfully creates a category" do
      expect {
        post categories_path, params: new_category
      }.must_differ 'Category.count', 1

      must_respond_with :redirect
      expect(flash[:success]).wont_be_nil

      updated_cat = Category.find_by(name: "test name")

      expect(updated_cat.name).must_equal new_category[:category][:name]
    end

    it "will not create product if params are invalid" do
      new_category[:category][:name] = nil

      expect {
        post categories_path, params: new_category
      }.wont_differ 'Category.count'

      expect(flash[:error]).wont_be_nil
    end
  end

  describe "destroy" do
    it "succesfully destroys category with valid id" do
      romantic = categories(:romantic)
      p romantic
      expect {
        delete category_path(romantic)
      }.must_differ "Category.count", -1

      must_respond_with :redirect
      expect(flash[:success]).wont_be_nil
    end

    it "responds with not_found given an invalid id" do
      expect {
        delete category_path(-1)
      }.wont_differ "Category.count"

      must_respond_with :not_found
    end
  end
end
