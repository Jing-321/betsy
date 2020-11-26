require "test_helper"

describe PaymentInfosController do
  let(:payment_hash) {
    {
        payment_info: {
            email: 'abc@email.com',
            address: '123 St. USA',
            credit_card_name: 'Jane Doe',
            credit_card_number: 123456789,
            credit_card_exp: '12/12',
            credit_card_CVV: 123,
            zip_code: 456789
            # user_id: user.id
        }
    }
  }

  let(:payment) {
    PaymentInfo.new(
        email: 'update@email.com',
        address: '467 St. USA',
        credit_card_name: 'John Doe',
        credit_card_number: 4953925,
        credit_card_exp: '10/10',
        credit_card_CVV: 543,
        zip_code: '98234',
        user_id: users(:jasmine).id
    )
  }
  describe "new" do
    it "successfully gets the new view" do
      perform_login
      get new_payment_info_path
      must_respond_with :success
    end
  end

  describe "create" do

    it "will create a payment info associated with a guest user if no one is logged in" do

      expect {
        post payment_infos_path, params: payment_hash
      }.must_differ "PaymentInfo.count", 1

      expect(flash[:success]).must_equal "Payment information received."
      must_redirect_to order_submit_path
      guest = User.find_by(username: "guest")
      payment = PaymentInfo.last
      expect(payment.user_id).must_equal guest.id
    end

    it "will not create payment info if paramaters are invalid" do
      payment_hash[:payment_info][:address] = nil
      expect {
        post payment_infos_path, params: payment_hash
      }.wont_differ "PaymentInfo.count"

      expect(flash[:error]).must_equal "Payment information invalid. Please try again."
      must_respond_with :bad_request
    end

    it "will create a payment info associated with a signed in user if someone is logged in" do
      user = users(:jasmine)
      perform_login(user)

      expect {
        post payment_infos_path, params: payment_hash
      }.must_differ "PaymentInfo.count", 1

      expect(flash[:success]).must_equal "Payment information received."
      must_redirect_to order_submit_path

      payment = PaymentInfo.last
      expect(payment.user_id).must_equal user.id
    end
  end

  describe "edit" do

    it "succesfully gets edit view" do
      payment.save!
      get edit_payment_info_path(payment)
      must_respond_with :success
    end

    it "returns not found if given an invalid id" do
      get edit_payment_info_path(-1)
      must_respond_with :not_found
    end
  end

  describe "update" do

    it "does not update if given an invalid id" do
      patch payment_info_path(-1)
      must_respond_with :not_found
    end

    it "succesfully updates payment with valid params" do
      payment.save!
      expect {
        patch payment_info_path(payment), params: payment_hash
      }.wont_differ "PaymentInfo.count"

      must_respond_with :redirect
      must_redirect_to order_submit_path
      expect(flash[:success]).must_equal "Payment information received."

      payment.reload
      expect(payment.email).must_equal payment_hash[:payment_info][:email]
      expect(payment.address).must_equal payment_hash[:payment_info][:address]
      expect(payment.credit_card_name).must_equal payment_hash[:payment_info][:credit_card_name]
      expect(payment.credit_card_exp).must_equal payment_hash[:payment_info][:credit_card_exp]
      expect(payment.credit_card_CVV).must_equal payment_hash[:payment_info][:credit_card_CVV]
      expect(payment.zip_code).must_equal payment_hash[:payment_info][:zip_code]
    end

    it "does not update payment with invalid params" do
      payment_hash[:payment_info][:address] = nil
      payment.save!
      expect {
        patch payment_info_path(payment), params: payment_hash
      }.wont_differ "PaymentInfo.count"

      must_respond_with :bad_request
      expect(flash[:error]).must_equal "Payment information invalid. Update failed."
    end
  end

  describe "destroy" do
    it "succesfully deletes payment with valid id" do
      perform_login
      payment.save!
      expect {
        delete payment_info_path(payment)
      }.must_differ "PaymentInfo.count", -1

      must_respond_with :redirect
      must_redirect_to user_path(session[:user_id])
    end

    it "does not delete if given an invalid id" do
      expect {
        delete payment_info_path(-1)
      }.wont_differ "PaymentInfo.count"
      must_respond_with :not_found
    end
  end
end
