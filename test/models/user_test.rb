require 'test_helper'

describe User do
  let(:user) {
    User.new(username: "hamza",
             uid: 54321,
             provider: "github",
             email: "ayesha@gmail.com",
             order_id: orders(:order1).id,
             product_id: products(:hawaii).id)
  }

  it 'can be instantiated' do
    expect(user.valid?).must_equal true
  end
  describe 'validations' do
    it 'is valid when all fields are present' do
      result = user.valid?
      expect(result).must_equal true
    end
    it "must have a valid 'username'" do
      user.username = "ayesha"
      result = user.valid?

      expect(result).must_be "ayesha"
    end

    it 'is invalid without a username' do
      user.username = nil
      result = user.valid?

      expect(result).must_equal false
    end
  end
  describe 'relationships' do
    it 'can have many orders' do
      result = user.order
      # Unsure of how to demonstrate the "order"
      expect(result).must_equal orders(:order1)
    end

    it 'can have many products' do
      result = user.product

      expect(result).must_equal products(:hawaii)
    end

    it 'can have many reviews' do
      # Do I need to make a "Review" yml file? for
      # this test to work?
    end

    it 'has one payment information (card information)' do
      result = user.payment_infos
      # Unsure of how to demonstrate the "order"
      expect(result).must_equal products(:hawaii)
    end
  end
  describe 'custom methods' do
    #Authorization first
    it "returns a user" do

    end
  end
end
