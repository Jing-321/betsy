class OrderItemsController < ApplicationController
  #before_action :find_product, only: :create

  def new
    @order_item = OrderItem.new(order_item_params)
  end

  def create
    new_qty = params["quantity"].to_i
    new_item = params["product_id"]

    #is there an existing order? if not, create a new Order
    if session[:order_id] == nil || session[:order_id] == false
      @order = Order.new(status: "pending")
      session[:order_id] = @order.id
    else
      @order.find_by(id: session[:order_id])
    end

    if new_qty + @order.current_quantity(new_item) > Product.find(new_item).stock
      flash.now[:error] = "This item is low in stock. Can't update cart." #not added
      redirect_to order_path(session[:order_id])
      return
    end

    if @order.confirm_order_items(new_item, new_qty) == false
      @order.order_items << OrderItem.create(
          quantity: new_qty,
          product_id: new_item,
          order_id: @order.id
      )
      flash[:success] = "Cart updated." #item added
      redirect_to product_path(params["product_id"])
      return
    end
  end

  def update
    @order_item.quantity = params[:new_qty]
    @order_item.save
    flash[:success] = "Quantity updated"
    redirect_to order_path(session[:order_id])
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    flash.now[:status] = :success
    flash.now[:result_text] = "#{@order_item.product.name} removed from cart."
    if session[:order_id]
      redirect_to shopping_cart_path
    else
      redirect_to root_path
    end
  end

  def increase_qty
    if session[:order_id] == nil || session[:order_id] == false
      flash[:error] = "Your cart is empty. Please add some adventures to it."
      redirect_to shopping_cart_path
      return
    end

    @order_item = OrderItem.find_by(id: params[:id])
    @product = @order_item.product.stock

    if @order_item.quantity < @product
      @order_item.quantity += 1
      @order_item.save
        flash[:success] = "Cart Updated."
    else
      flash[:error] = "No additional tours can be booked at this time."
    end
    redirect_to shopping_cart_path
    return
  end

  def decrease_qty
    if session[:order_id] == nil || session[:order_id] == false
      flash[:error] = "Your cart is empty. Please add some adventures to it."
      redirect_to shopping_cart_path
      return
    end

    @order_item = OrderItem.find_by(id: params[:id])

    if @order_item.quantity > 1
      @order_item.quantity -= 1
      @order_item.save
      flash[:success] = "Quantity updated."
      redirect_to shopping_cart_path
      return
    else
      @order_item.delete
      flash[:success] = "#{@order_item.product.name} has been removed from cart."
      redirect_to shopping_cart_path
      return
    end


  end

  private

  def order_item_params
    return params.require(:order_item).permit(:quantity, :product_id, :order_id)
  end
end




