class OrdersController < ApplicationController

  before_action :find_order, only: [:submit, :submit]
  before_action :current, only: [:show, :submit]

  def show
    @order = Order.find(params[:id])
    @items = @order.order_items.order(created_at: :desc)
    if @order.user_id != session[:user_id]
      @items = @items.select {|item| Product.find(item.product_id).user_id == session[:user_id]}
    end
    return
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

  # def destroy
  #   @order.destroy
  #   redirect_to user_path(params[:user_id])
  # end

  def submit
    @order.status = "complete"
    @items = @order.order_items
    @items.each do |item|
      product = Product.find(item.product_id)
      product.stock -= item.quantity
      product.save
    end
    @order.save
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

  def current
    @current_user = User.find_by(id: session[:user_id])
    unless @current_user
      flash[:error] = 'You must be logged in to see this page'
      redirect_to root_path
      return
    end
  end
end
