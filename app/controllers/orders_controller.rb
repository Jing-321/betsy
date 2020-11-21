class OrdersController < ApplicationController

  before_action :find_order, only: [:submit, :checkout]



  def find_order
    @order = Order.find_by(session[:order_id])
    if @order.nil?
      flash[:error] = "Sorry, can't find the order."
      return redirect_to root_path
    end
  end

  # def index
  #   if params[:user_id]
  #     user = User.find_by(id: params[:user_id])
  #     @orders = user.orders
  #   end
  # end

  def show
    @order = Order.find_by(session[:order_id])

    if @order.nil?
      @items = []
    else
      @items = @order.order_items.order(created_at: :desc)
    end
  end

  def shopping_cart
    @order = Order.find_by(session[:order_id])
    @current_user = User.find(session[:user_id])

    if @order.nil?
      @items = []
    else
      @items = @order.order_items.order(created_at: :desc)
    end
  end

  def destroy
    @order.destroy
    redirect_to user_path(params[:user_id])
  end

  def checkout
    @order = Order.find_by(session[:order_id])
    if @order.nil?
      flash[:error] = "There is nothing in your cart."
      return redirect_to shopping_cart_path
    end
    @current_user = User.find_by(id: session[:user_id])
    @order = Order.find(session[:order_id])



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
