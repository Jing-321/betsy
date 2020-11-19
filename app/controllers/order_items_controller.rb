class OrderItemsController < ApplicationController
  before_action :find_product, only: :create

  def create

  end

  # def update
  #   new_item = @order_item.product
  #   qty = order_item_params[:quantity].to_i
  #
  #   if qty > new_item.stock
  #     flash[:status] = :failure
  #     flash[:result_text] = "#{new_item.name} is low in stock. Cannot add item to cart."
  #     redirect_to order_path
  #     return
  #   else
  #     @order_item.update(order_item_params)
  #     flash[:status] = :success
  #     flash[:result_text] = "#{new_item.name} added to cart."
  #     redirect_to order_path
  #     return
  #   end
  # end

  def increase_quantity

    product = Product.find_by!(id: params[:product_id]).stock #please check

    session[:order].each do |item|
      if item["product_id"] == params["product_id"].to_i && item["quantity"] < product
        item["quantity"] += 1
        flash[:success] = "#{product[:name]} added to shopping cart."
      elsif item["product_id"] == params["product_id"].to_i && item['quantity'] == product
        flash[:error] = "#{product[:name]} is low in stock. No additional units can be added to cart."
      end
    end

    redirect_to order_items_path
    return
  end


  def decrease_quantity
    session[:order].each do |item|
      current_item = Product.find(item["product_id"])
      if current_item.quantity == 0
        flash[:error] = "Something is wrong. There is no #{current_item.name} in your cart."
        redirect_back(fallback_location: order_items_path)
        return
      end

      if item["product_id"] == params['format'].to_i
        item["quantity"] > 1 ? item["quantity"] -= 1 : session[:cart].delete(item)
      end
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
    return params.require(:order_item).permit(:quantity, :product_id, :order_id)
  end
  end
end

