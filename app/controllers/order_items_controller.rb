class OrderItemsController < ApplicationController
  before_action :find_product, only: :create
  # before_action :validate_quantity, only: [:create, :update]

  def create
    # @book = Book.new(book_params)
    #
    # if @book.save
    #   redirect_to :action => 'list'
    # else
    #   @subjects = Subject.all
    #   render :action => 'new'
    # end

    qty = params["quantity"].to_i
    new_item = params["product_id"]  #Product.find_by(id: params["product_id"])

    if session[:order_id] == nil
      @order = Order.new(status: "pending")
      session[:order_id] = @order.id
    else
      @order.find_by(id: session[:order_id])
    end

    session[:order].each do |item|
      if item["product_id"] == new_item.id
        if item["quantity"] < new_item.stock
          item["quantity"] += 1
          flash[:sucess] = "#{item.name} added to cart."
          redirect_to order_path
          return
        elsif item["quantity"] == new_item.stock
          flash[:error] = "#{item.name} is low in stock. Can't add to the cart."
          redirect_to order_path
          return
        end
      end
    end

    #def update

    @order_item = OrderItem.new(quantity: qty, product_id: new_item.id, id: @order.id)
    if @order_item.save
      session[:order] << @order_item     #array ?
      flash[:success] = "#{new_item.name} added to the cart."
      redirect_to product_path(new_item)
      return
    else
      flash.now[:error] = "Something is wrong. Can't add #{Product.find_by(id: @order_item.product_id).name}"
      render :new, status: :bad_request
      return
    end

    flash[:error] = "#{new_item.name} is low in stock. Can't add to the cart."
    #end

  end

  def increase_quantity #work in progress

    product = Product.find_by!(id: params[:product_id]).stock #please check

    session[:order].each do |item|
      if item["product_id"] == params["product_id"].to_i && item["quantity"] < product
        item["quantity"] += 1
        flash[:success] = "#{product[:name]} added to shopping cart."
      elsif item["product_id"] == params["product_id"].to_i && item['quantity'] == product
        flash[:error] = "#{product[:name]} is low in stock. No additional units can be added to cart."
      end
    end

    fallback_location = order_items_path
    redirect_back(fallback_location: fallback_location)
    return
  end


  def decrease_quantity #work in progress
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

    flash[:success] = "Item removed from shopping cart."
    fallback_location = order_items_path
    redirect_back(fallback_location: fallback_location)
    return
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




