class OrderItemsController < ApplicationController
  before_action :find_product, only: :create
  # before_action :validate_quantity, only: [:create, :update]

  def create
    #is there an existing order? if not, create a new Order
    if session[:order_id] == nil || session[:order_id] == false
      @order = Order.new(status: "pending")
      unless @order.save
        flash[:error] = "Something went wrong. Please refresh and try again."
      end
      session[:order_id] = @order.id

    else
      @order.find_by(id: session[:order_id])
    end

    #if current order already contains the product, increase amount; else, add new item
    @order_item = OrderItem.find_by(product_id: params[:product_id], order_id: session[:order_id])
    if @order_item
      @order_item.quantity += params[:order_item][:quantity].to_i
    else
      @order_item = OrderItem.new(
          quantity: params[:order_item][:quantity],
          product_id: params[:product_id],
          order_id: @order.id
      )
    end

    #check validation

    if @order_item.save
      flash[:success] = "#{@order_item.product.name} added to the cart."
      redirect_to order_path #check if this is the path we want
      return
    else
      flash.now[:error] = "Something is wrong. Can't add item to cart."
      render :new, status: :bad_request
      redirect_to order_path #check if this is the path we want
      return
    end
  end

  # def increase_quantity #work in progress
  #   new_item = Product.find_by!(id: params[:product_id]).stock #please check if params[:product_id] is correct here -- and for the following
  #
  #   session[:order].each do |item|
  #     if item["product_id"] == params["product_id"].to_i && item["quantity"] < new_item #here
  #       item["quantity"] += 1
  #       flash[:success] = "#{new_item.name} added to shopping cart."
  #     elsif item["product_id"] == params["product_id"].to_i && item['quantity'] == product  #here
  #       flash[:error] = "#{product[:name]} is low in stock. Can't add more to the cart."
  #     end
  #   end
  #   redirect_to order_items_path
  #   return
  # end
  #
  #
  # def decrease_quantity #work in progress
  #   session[:order].each do |item|
  #     current_item = Product.find(item["product_id"])
  #     if current_item.quantity == 0
  #       flash[:error] = "There is currently no #{current_item.name} in your cart."
  #       redirect_back(fallback_location: order_items_path)
  #       return
  #     end
  #
  #     if item["product_id"] == params["product_id"].to_i  #here
  #       item["quantity"] > 1 ? item["quantity"] -= 1 : session[:order].delete(item)
  #     end
  #   end
  #   flash[:success] = "Item removed from cart."
  #   redirect_to order_items_path
  #   return
  # end


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




