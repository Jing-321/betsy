class PaymentInfosController < ApplicationController
  before_action :find_payment_info, only: [:edit, :update, :destroy]

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
    if session[:user_id].nil?
      guest = User.create(username: "guest")
      User.find(@payment_info.user_id).username = @payment_info.email
      @payment_info.user_id = guest.id
    else
      @payment_info.user_id = session[:user_id]
    end

    if @payment_info.save

        flash[:success] = "Payment information received."
        return redirect_to order_submit_path
      else
        flash.now[:error] = "Payment information invalid. Please try again."
        return render :new, status: :bad_request
      end
  end

  def edit
    if @payment_info.nil?
      head :not_found
      return
    end
  end

  def update
    if @payment_info.nil?
      head :not_found
      return
    elsif @payment_info.update(payment_info_params)
      flash[:success] = "Payment information received."
      return redirect_to order_submit_path
    else
      flash.now[:error] = "Payment information invalid. Update failed."
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    if @payment_info.nil?
      head :not_found
      return
    end

    @payment_info.destroy
    redirect_to user_path(session[:user_id])
    return
  end


  private

  def payment_info_params
    return params.require(:payment_info).permit(:user_id, :email, :address, :credit_card_name, :credit_card_number, :credit_card_exp, :credit_card_CVV, :zip_code)
  end

  def find_payment_info
    @payment_info = PaymentInfo.find(params[:id])
  end
end
