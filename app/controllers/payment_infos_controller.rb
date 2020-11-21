class PaymentInfosController < ApplicationController
  def new
    @current_user = User.find(session[:user_id])
    if @current_user
      @payment_info = PaymentInfo.new(user_id: @current_user.id, email: @current_user.email)
    else
      @payment_info = PaymentInfo.new(user_id: session[:user_id])
    end
  end

  def create
    @payment_info = PaymentInfo.new(payment_info_params)
    if @payment_info.save
      flash[:success] = "Payment information received."
      return redirect_to order_confirmation
    else
      flash.now[:error] = "Payment information invalid. Please try again."
      return render :new, status: :bad_request
    end
  end


end
