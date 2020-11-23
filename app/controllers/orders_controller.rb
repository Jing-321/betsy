class OrdersController < ApplicationController

  before_action :find_order, only: [:submit, :checkout, :submit]


  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      @orders = user.orders
    end
  end

  def show
    @order = Order.find_by(id: session[:order_id])

    if session[:order_id].nil?
      @items = []
    else
      @items = @order.order_items.order(created_at: :desc)
    end
  end

  def shopping_cart
    if session[:user_id].nil?
      if session[:order_id].nil?
        @items = []
      else
        @order = Order.find(session[:order_id])
        @items = @order.order_items.order(created_at: :desc)
      end

    else
      @current_user = User.find(session[:user_id])
      if session[:order_id].nil?
        @items = []
      else
        @order = Order.find(session[:order_id])
        @items = @order.order_items.order(created_at: :desc)
      end
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
    @order.status = "completed"
    @items = @order.order_items
    @items.each do |item|
      product = Product.find(item.product_id)
      product.stock -= item.quantity
      product.save
    end
    session[:order_id] = nil
    return
  end

  private
  def order_params
    return params.require(:order).permit(:user_id, :status)
  end

  def find_order
    @order = Order.find(session[:order_id])
    if @order.nil?
      flash[:error] = "Sorry, can't find the order."
      return redirect_to root_path
    end
  end
end
