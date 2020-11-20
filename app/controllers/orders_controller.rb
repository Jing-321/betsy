class OrdersController < ApplicationController

  before_action :find_order, only: [:show, :destroy, :checkout, :submit]

  def find_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "Sorry, can't find the order."
      return redirect_to root_path
    end
  end

  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      @orders = user.orders
    end
  end

  def show
    @items = @order.items.order(created_at: :desc)
  end

  def empty_cart
    @current_user = User.find(session[:user_id])
  end

  def destroy
    @order.destroy
    redirect_to user_path(params[:user_id])
  end

  def payment
    @user = User.find(params[:user_id])



  end

  def submit
    #### check address & payment
    if @order.nil?
      head :not_found
      return
    else

      @order.status = "completed"
      @items = @order.order_item
      @items.each do |item|
        Product.find(item.product).stock -= item.quantity
      end
    end
  end

  private
  def order_params
    return params.require(:order).permit(:user_id, :status)
  end

end
