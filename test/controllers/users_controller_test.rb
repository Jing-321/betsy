require "test_helper"

describe UsersController do
  describe "index" do
    it "can list users with listing products" do

    end

    it "will not list users without listing products" do

    end
  end

  describe "create" do

  end

  describe "destroy" do
    it "can logout current user" do
      session[:user_id] = users(:jing)
      expect{
        delete users_path
      }.wont_change 'User.count'

      expect(session[:user_id]).must_equal nil
    end
  end

end
