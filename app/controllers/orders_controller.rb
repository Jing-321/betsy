class OrdersController < ApplicationController

  before_action :find_order, only: [:show, :update, :destroy, :submit]

  def find_order
    @order = Order.find_by(id: params[:id])
  end

  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      @orders = user.orders
    end
  end

  def show
    if @order.nil?
      head :not_found
      return
    end
    @items = @order.items.order(created_at: :desc)
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:success] = "#{@order.items.product.name} has been added to your cart!"
      redirect_to order_path(@order)
    else
      product = Product.find(params[:id])
      flash[:failure] = "Sorry, can't add #{product.name} to your cart."
      flash[:message] = @order.errors.message
      redirect_to product_path(product.id)
    end
  end

  def update
    if @order.nil?
      head :not_found
      return
    end
  end

  def destroy
    if @order.nil?
      head :not_found
      return
    end
    @user = @order.user
    @order.destroy
    redirect_to user_path(@user)
  end

  def submit
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
    return params.require(:order).permit(:user, :status)
  end

end
