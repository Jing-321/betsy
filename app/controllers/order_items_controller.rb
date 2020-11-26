class OrderItemsController < ApplicationController

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