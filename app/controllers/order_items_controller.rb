class OrderItemsController < ApplicationController

  def create

  end

  def edit

  end

  def update

  end

  def delete_item  #destroy
    @order_item.destroy
    flash.now[:status] = :success
    flash.now[:result_text] = "#{@order_item.product.name} removed from cart"
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
