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
    end

    it "will not list users without listing products" do
      #how?
    end
  end

  describe "create" do
    it "can login an existing user" do
      perform_login(users(:jing))
      must_respond_with :redirect
    end

    it "can login a new user" do
      new_user = User.new(username: "test", provider: "github", uid: 123, photo_url: "url", email:"a@a.com")
      expect {user = perform_login(new_user)}.must_change 'User.count', 1

      must_respond_with :redirect
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

  describe "user_account" do
    it "will respond success for logged in user" do
      perform_login(users(:jing))
      get user_account_path
      must_respond_with :success
    end

    it "will redirect to homepage if user not logged in" do
      get user_account_path
      must_redirect_to root_path
    end
  end

  describe "order_history" do
    it "will respond success for logged in user" do
      perform_login(users(:jing))
      get order_history_path
      must_respond_with :success
    end

    it "will redirect to homepage if user not logged in" do
      get order_history_path
      must_redirect_to root_path
    end
  end

  describe "manage_tours" do
    it "will respond success for logged in user" do
      perform_login(users(:jing))
      get manage_tours_path
      must_respond_with :success
    end

    it "will redirect to homepage if user not logged in" do
      get manage_tours_path
      must_redirect_to root_path
    end
  end

end
