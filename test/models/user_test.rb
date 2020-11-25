require 'test_helper'

describe User do
  let(:user) {
    User.new(username: 'hamza',
             uid: 54321,
             provider: 'github',
             email: 'ayesha@gmail.com')
             # order_id: orders(:order1).id,
             # product_id: products(:hawaii).id)
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
      result = user.valid?

      expect(result).must_equal true
    end

    it 'is invalid without a username' do
      user.username = nil
      result = user.valid?

      expect(result).must_equal false
    end
  end
  describe 'relationships' do
    it 'can have many orders' do
      result = users(:ayesha).orders

      expect(result.count).must_equal 2
      expect(result).must_include orders(:order3)
      expect(result).must_include orders(:order4)
    end

    it 'can have many products' do
      result = users(:denise).products

      expect(result.count).must_equal 2
      expect(result).must_include products(:disney)
      expect(result).must_include products(:lahore)
    end

    it 'has one payment information (card information)' do
      # validates :email, presence: true
      # validates :address, presence: true
      # validates :credit_card_name, presence: true
      # validates :credit_card_number, presence: true,
      #           numericality: true
      # validates :credit_card_exp, format: {with: /\d\d\/\d\d/, message: "Please use MM/YY format" }
      # validates :credit_card_CVV, numericality: true
      # validates :zip_code, format: {with: /\d{5}/, message: "Please enter your 5-digit zip code."}
      user.save
      payment = PaymentInfo.create(
        email: 'abc@email.com',
        address: '123 St. USA',
        credit_card_name: 'Jane Doe',
        credit_card_number: 123456789,
        credit_card_exp: '12/12',
        credit_card_CVV: 123,
        zip_code: '456789',
        user_id: user.id)



      result = user.payment_infos

      expect(result).must_include payment
    end
  end
  describe 'custom methods' do
    #Authorization first

    it 'returns a user' do
      user_params = {
        uid: 123456789,
        'info' => {provider: 'github',
                   username: 'hamid',
                   email: 'abc@email.com',
                   photo_url: 'example.url'}
      }
      expect(User.build_from_github(user_params)).must_be_instance_of User
    end
  end
end
