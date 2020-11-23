require "test_helper"

describe UsersController do
  # describe "create" do
  #   it "will returns 200 for a logged-in user" do
  #     perform_login
  #
  #     get
  #   end
  #
  # end

  describe "index" do
    it "can list users with listing products" do
      get "/products"
      must_respond_with :success
      ####how???
    end

    it "will not list users without listing products" do

    end
  end

  describe "destroy" do
    it "can logout current user" do
      perform_login
      expect(session[:user_id]).wont_be_nil
      delete logout_path
      expect(session[:user_id]).must_be_nil
      must_redirect_to root_path
    end
  end

  describe "show" do
    it "will get show for valid user id" do

    end
  end

end
