class OrderItemsController < ApplicationController
  before_action :find_product, only: :create

  def create
    new_id = params["product_id"]
    new_qty = params["quantity"]

    if session[:order_id] == nil || session[:order_id] == false || !session[:order_id]
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    else
      @order = Order.find_by(id: session[:order_id])
    end

    if new_qty.to_i + @order.current_qty(new_id) > Product.find(new_product_id).stock #check order model for "current quantity"
      flash.now[:status] = :danger
      flash.now[:result_text] = "Error: please check product availability."
      render 'products/main', status: :bad_request
      return
    end

  end

  def edit


  end

  def update
    @order_item.quantity = params[:new_quantity]
    @order_item.save
    flash[:status] = :success
    flash[:result_text] = "Cart updated."
    redirect_to order_path(session[:order_id])
  end

  def delete_item  #destroy
    @order_item.destroy
    flash.now[:status] = :success
    flash.now[:result_text] = "#{@order_item.product.name} removed from cart."
    if session[:order_id]
      redirect_to order_path(session[:order_id])
    else
      redirect_to root_path
    end
  end


  private

  def order_item_params
    return params.require(:order_item).permit(:quantity, :product_id, :order_id) #will order_id be really needed, though?
  end
end
